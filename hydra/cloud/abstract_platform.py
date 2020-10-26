import subprocess

class AbstractPlatform():
    def __init__(self, model_path, options):
        self.model_path = model_path
        self.options = options

    def train(self):
        raise Exception("Not Implemented: Please implement this function in the subclass.")

    def serve(self):
        raise Exception("Not Implemented: Please implement this function in the subclass.")

    def run_command(self, command):
        subprocess.run(command)
