import os
from hydra.cloud.abstract_platform import AbstractPlatform

class FastLocalPlatform(AbstractPlatform):
    def __init__(self, model_path, prefix_params):
        super().__init__(model_path, prefix_params)

    def train(self):
        os.system(" ".join([self.prefix_params, 'python3', self.model_path]))
        return 0

    def serve(self):
        pass
