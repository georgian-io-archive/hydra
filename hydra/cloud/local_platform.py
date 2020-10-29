import os
import subprocess
from hydra.cloud.abstract_platform import AbstractPlatform

class LocalPlatform(AbstractPlatform):
    def __init__(self, model_path, options, git_url, commit_sha, github_token):
        self.git_url = git_url
        self.commit_sha = commit_sha
        self.github_token = github_token

        self.script_path = os.path.join(os.path.dirname(__file__), '../../docker/local_execution.sh')

        super().__init__(model_path, options)

    def train(self):
        command = ['sh', self.script_path, '-g', self.git_url, '-c', self.commit_sha,
            '-o', self.github_token, '-m', self.model_path, '-p', self.options]

        self.run_command(command)
        return 0

    def serve(self):
        pass
