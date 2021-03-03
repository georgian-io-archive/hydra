import os
import json
import uuid
import subprocess
import boto3
from hydra.cloud.abstract_platform import AbstractPlatform

class AWSPlatform(AbstractPlatform):

    def __init__(
            self,
            model_path,
            project_name,
            git_url,
            commit_sha,
            github_token,
            cpu,
            memory,
            gpu_count,
            image_tag,
            image_url,
            options,
            region):

        self.project_name = project_name
        self.git_url = git_url
        self.commit_sha = commit_sha
        self.github_token = github_token

        self.image_tag = image_tag
        self.image_url = image_url

        self.cpu = cpu
        self.memory = memory
        self.gpu_count = str(gpu_count)

        self.region = region

        self.job_name = f"{self.project_name}_{uuid.uuid1()}"
        self.hydra_code_dump_uri = f's3://hydra-code-dumps/{self.job_name}'

        self.batch = boto3.client(
            service_name='batch',
            region_name='us-east-1',
            endpoint_url='https://batch.us-east-1.amazonaws.com'
        )

        super().__init__(model_path, options)
        self.options['HYDRA_GIT_URL'] = self.git_url
        self.options['HYDRA_COMMIT_SHA'] = self.commit_sha
        self.options['HYDRA_OAUTH_TOKEN'] = self.github_token
        self.options['HYDRA_MODEL_PATH'] = self.model_path
        self.options['HYDRA_PLATFORM'] = 'aws'

    def upload_code_to_s3(self):
        command = ['aws s3 cp --quiet --recursive',
                   '--exclude ".git/*" --exclude ".idea/*"',
                   '--exclude "tmp/*" .',
                   self.hydra_code_dump_uri]

        command = " ".join(command)

        subprocess.run(command, shell=True)
        print(f"Pushed code to {self.hydra_code_dump_uri} \n")
        return 0

    def train(self):
        # create job definition

        self.upload_code_to_s3()

        job_def_name = f"job-def-{self.job_name}"
        environment_list = []

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
                'image': '823217009914.dkr.ecr.us-east-1.amazonaws.com/hydra:master',
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




