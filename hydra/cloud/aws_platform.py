import os
import json
import uuid
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

        self.batch = boto3.client(
            service_name = 'batch',
            region_name='us-east-1',
            endpoint_url='https://batch.us-east-1.amazonaws.com'
        )

        super().__init__(model_path, options)
        self.options['HYDRA_GIT_URL'] = self.git_url
        self.options['HYDRA_COMMIT_SHA'] = self.commit_sha
        self.options['HYDRA_OAUTH_TOKEN'] = self.github_token
        self.options['HYDRA_MODEL_PATH'] = self.model_path
        self.options['HYDRA_PLATFORM'] = 'aws'

    def train(self):
        # create job definition
        jobName = f"{self.project_name}_{uuid.uuid1()}"
        jobDefName = f"job-def-{jobName}"
        jobQueue = 'hydra-ml-queue'
        environment_list = []

        for k, v in self.options.items():
            environment_list.append(
                {
                    "name": k,
                    "value": str(v)
                }
            )

        resp = self.batch.register_job_definition(
            jobDefinitionName=jobDefName,
            type='container',
            containerProperties={
                'image': '823217009914.dkr.ecr.us-east-1.amazonaws.com/hydra:master',
                'vcpus': self.cpu,
                'memory': self.memory*1000,
                'privileged': True,
                'environment': environment_list
            }
        )
        print(resp)
        submitJobResponse = self.batch.submit_job(
            jobName=jobName,
            jobQueue=jobQueue,
            jobDefinition=jobDefName
        )

        jobId = submitJobResponse['jobId']
        print('Submitted job [%s - %s] to the job queue [%s]' % (jobName, jobId, jobQueue))




