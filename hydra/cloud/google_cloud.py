import os
from hydra.cloud.abstract_platform import AbstractPlatform

class GoogleCloud(AbstractPlatform):
    def __init__(self, model_path, prefix_params, git_url, commit_sha, github_token, tag, region="us-west2"):

        self.git_url = git_url
        self.commit_sha = commit_sha
        self.github_token = github_token
        self.region = region
        self.tag = tag

        self.script_path = os.path.join(os.path.dirname(__file__), '../../docker/gcp_execution.sh')

        super().__init__(model_path, prefix_params)

    def train(self):
        command = ['sh', self.script_path, '-g', self.git_url,
            '-c', self.commit_sha, '-o', self.github_token, '-m', self.model_path,
            '-r', self.region, '-t', self.tag, '-p', self.prefix_params]

        self.run_command(command)
        return 0

    def serve(self):
        pass
