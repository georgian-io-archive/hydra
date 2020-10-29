import os
from hydra.cloud.abstract_platform import AbstractPlatform

class FastLocalPlatform(AbstractPlatform):
    def __init__(self, model_path, options):
        super().__init__(model_path, options)

    def train(self):
        os.system(" ".join([self.options, 'python3', self.model_path]))
        return 0

    def serve(self):
        pass
