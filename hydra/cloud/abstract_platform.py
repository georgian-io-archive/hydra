import subprocess

class AbstractPlatform():
    def __init__(self, model_path, options):
        self.model_path = model_path
        self.options = options

    def copy_project_to_cloud(self):
        raise NotImplementedError("Not Implemented: Please implement this function in the subclass.")

    def train(self):
        raise NotImplementedError("Not Implemented: Please implement this function in the subclass.")

    def serve(self):
        raise NotImplementedError("Not Implemented: Please implement this function in the subclass.")

    def run_command(self, command):
        subprocess.run(command)
