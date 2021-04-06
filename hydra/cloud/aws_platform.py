import os
import json
import uuid
import subprocess
import boto3
from hydra.cloud.abstract_platform import AbstractPlatform
import sqlalchemy
import pymysql
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
            region_name='us-east-1',
            endpoint_url='https://batch.us-east-1.amazonaws.com'
        )
        self.secret = boto3.client('secretsmanager')

        super().__init__(model_path, options)
        self.options['HYDRA_GIT_URL'] = self.git_url
        self.options['HYDRA_COMMIT_SHA'] = self.commit_sha
        self.options['HYDRA_OAUTH_TOKEN'] = self.github_token
        self.options['HYDRA_MODEL_PATH'] = self.model_path
        self.options['HYDRA_PLATFORM'] = 'aws'

        self.init_metadata_db_connection()

    def init_metadata_db_connection(self):
        username_secret = self.secret.get_secret_value(SecretId=self.metadata_db_username_secret)['SecretString']
        password_secret = self.secret.get_secret_value(SecretId=self.metadata_db_password_secret)['SecretString']

        self.db_connection = sqlalchemy.create_engine(f'mysql+pymysql://{username_secret}:'
                                                      f'{password_secret}@'
                                                      f'{self.metadata_db_hostname}:'
                                                      f'3306/{self.metadata_db_name}').connect()

    def upload_code_to_s3(self):
        command = ['aws s3 cp --quiet --recursive',
                   '--exclude ".git/*" --exclude ".idea/*"',
                   '--exclude "tmp/*" .',
                   self.hydra_code_dump_uri]

        command = " ".join(command)

        subprocess.run(command, shell=True)
        print(f"Pushed code to {self.hydra_code_dump_uri} \n")
        return 0

    def insert_job_attributes(self, job_id):
        ip = get('https://checkip.amazonaws.com').text.strip()

        self.db_connection.execute(f'''
            INSERT INTO job_attribute SET k='Location', v='Batch', job_id={job_id};
        ''')
        self.db_connection.execute(f'''
            INSERT INTO job_attribute SET k='Username', v='{getpass.getuser()}', job_id={job_id};
        ''')
        self.db_connection.execute(f'''
            INSERT INTO job_attribute SET k='IP Address', v='{ip}', job_id={job_id};
        ''')
        self.db_connection.execute(f'''
            INSERT INTO job_attribute SET k='Image URI', v='{self.image_url}:{self.image_tag}', job_id={job_id};
        ''')
        self.db_connection.execute(f'''
            INSERT INTO job_attribute SET k='Hydra Version', v='{self.hydra_version}', job_id={job_id};
        ''')

    def train(self):
        # create job definition
        job_def_name = f"job-def-{self.job_name}"
        environment_list = []

        self.db_connection.execute(f'''
            INSERT INTO job SET
            type_id=3,
            name='{self.job_name}',
            job_uuid='{self.uuid}',
            args='{json.dumps(self.options)}';
        ''')
        current_job_proxy = self.db_connection.execute('SELECT MAX(id) FROM job;')
        current_job_id = current_job_proxy.fetchall()[0][0]

        self.upload_code_to_s3()
        self.insert_job_attributes(current_job_id)

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




