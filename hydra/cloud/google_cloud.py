import os
import subprocess
from hydra.cloud.abstract_platform import AbstractPlatform

class GoogleCloud(AbstractPlatform):
    def __init__(self, model_path, prefix_params, git_url, commit_sha, github_token):
        self.git_url = git_url
        self.commit_sha = commit_sha
        self.github_token = github_token
        super().__init__(model_path, prefix_params)

    def train(self):
        execution_script_path = os.path.join(os.path.dirname(__file__), '../../docker/gcp_execution.sh')
        command = ['sh', execution_script_path, self.git_url, self.commit_sha,
            self.github_token, self.model_path, self.prefix_params]

        subprocess.run(command)
        return 0

    def serve(self):
        pass
