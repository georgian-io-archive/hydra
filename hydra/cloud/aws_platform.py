import os
import uuid
import subprocess
import boto3
from hydra.cloud.abstract_platform import AbstractPlatform
import getpass
from requests import get

class AWSPlatform(AbstractPlatform):

    def __init__(
            self,
            model_path,
            project_name,
            git_url,
            commit_sha,
            github_token,
            hydra_version,
            cpu,
            memory,
            gpu_count,
            metadata_db_hostname,
            metadata_db_username_secret,
            metadata_db_password_secret,
            metadata_db_name,
            image_tag,
            image_url,
            options,
            region):

        self.project_name = project_name
        self.git_url = git_url
        self.commit_sha = commit_sha
        self.github_token = github_token
        self.hydra_version = hydra_version

        self.metadata_db_hostname = metadata_db_hostname
        self.metadata_db_username_secret = metadata_db_username_secret
        self.metadata_db_password_secret = metadata_db_password_secret
        self.metadata_db_name = metadata_db_name

        self.image_tag = image_tag or 'master'
        self.image_url = image_url or 'public.ecr.aws/l6k7f2t9/hydra'

        self.cpu = cpu
        self.memory = memory
        self.gpu_count = str(gpu_count)

        self.region = region

        self.uuid = uuid.uuid1()
        self.job_name = f"{self.project_name}_{self.uuid}"
        self.hydra_code_dump_uri = f's3://hydra-code-dumps/{self.job_name}'

        self.batch = boto3.client(
            service_name='batch',
            region_name=region,
            endpoint_url=f'https://batch.{region}.amazonaws.com'
        )
        self.secret = boto3.client('secretsmanager')

        super().__init__(model_path, options)
        self.options['HYDRA_GIT_URL'] = self.git_url
        self.options['HYDRA_COMMIT_SHA'] = self.commit_sha
        self.options['HYDRA_OAUTH_TOKEN'] = self.github_token
        self.options['HYDRA_MODEL_PATH'] = self.model_path
        self.options['HYDRA_PLATFORM'] = 'aws'

        self.options['HYDRA_METADATA_DB_HOSTNAME'] = self.metadata_db_hostname
        self.options['HYDRA_METADATA_DB_USERNAME_SECRET'] = self.metadata_db_username_secret
        self.options['HYDRA_METADATA_DB_PASSWORD_SECRET'] = self.metadata_db_password_secret
        self.options['HYDRA_METADATA_DB_NAME'] = self.metadata_db_name

    def upload_code_to_s3(self):
        command = ['aws s3 cp --quiet --recursive',
                   '--exclude ".git/*" --exclude ".idea/*"',
                   '--exclude "tmp/*" .',
                   self.hydra_code_dump_uri]

        command = " ".join(command)

        subprocess.run(command, shell=True)
        print(f"Pushed code to {self.hydra_code_dump_uri} \n")
        return 0

    def insert_job_attributes(self):
        self.options['ATTRIBUTE_JOB_UUID'] = self.uuid
        self.options['ATTRIBUTE_JOB_NAME'] = self.job_name
        self.options['ATTRIBUTE_JOB_LOCATION'] = 'Batch'
        self.options['ATTRIBUTE_USERNAME'] = getpass.getuser()
        self.options['ATTRIBUTE_IP_ADDRESS'] = get('https://checkip.amazonaws.com').text.strip()
        self.options['ATTRIBUTE_IMAGE_URI'] = f'{self.image_url}:{self.image_tag}'
        self.options['ATTRIBUTE_HYDRA_VERSION'] = self.hydra_version

    def run(self):
        # create job definition
        job_def_name = f"job-def-{self.job_name}"
        environment_list = []

        self.upload_code_to_s3()
        self.insert_job_attributes()

        if int(self.gpu_count) > 0 :
            job_queue = 'hydra-gpu-queue'
        else:
            job_queue = 'hydra-ml-queue'

        for k, v in self.options.items():
            environment_list.append(
                {
                    "name": k,
                    "value": str(v)
                }
            )

        environment_list.append({
            "name": "HYDRA_CODE_DUMP_URI",
            "value": self.hydra_code_dump_uri
        })

        container_properties_dict = {
                'image': f'{self.image_url}:{self.image_tag}',
                'vcpus': self.cpu,
                'memory': self.memory*1000,
                'privileged': True,
                'environment': environment_list
        }

        if int(self.gpu_count) > 0:
            container_properties_dict['resourceRequirements'] = [
                    {
                        'value': self.gpu_count,
                        'type': 'GPU'
                    }
                ]

        resp = self.batch.register_job_definition(
            jobDefinitionName=job_def_name,
            type='container',
            containerProperties=container_properties_dict
        )
        submit_job_response = self.batch.submit_job(
            jobName=self.job_name,
            jobQueue=job_queue,
            jobDefinition=job_def_name
        )
        job_id = submit_job_response['jobId']
        print('Submitted job [%s - %s] to the job queue [%s]' % (self.job_name, job_id, job_queue))




