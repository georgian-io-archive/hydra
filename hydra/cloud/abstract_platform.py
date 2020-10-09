

class AbstractPlatform():
    def __init__(self, model_path, prefix_params=""):
        self.model_path = model_path
        self.prefix_params = prefix_params

    def train(self):
        raise Exception("Not Implemented: Please implement this function in the subclass.")

    def serve(self):
        raise Exception("Not Implemented: Please implement this function in the subclass.")
