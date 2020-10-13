from hydra.cloud.abstract_platform import AbstractPlatform

class GoogleCloud(AbstractPlatform):
    def __init__(self, model_path, prefix_params, git_url, commit_sha, github_token):
        self.git_url = git_url
        self.commit_sha = commit_sha
        self.github_token = github_token
        super().__init__(model_path, prefix_params)

    def train(self):
        pass

    def serve(self):
        pass
