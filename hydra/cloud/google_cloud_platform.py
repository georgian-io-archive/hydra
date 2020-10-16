import os
import json
from hydra.cloud.abstract_platform import AbstractPlatform

class GoogleCloudPlatform(AbstractPlatform):

    CPU_COST_PER_HOUR = 0.021811
    MEMORY_COST_PER_HOUR = 0.002923

    def __init__(self, model_path, prefix_params, git_url, commit_sha, github_token, tag, cpu, memory, region="us-west2"):

        self.git_url = git_url
        self.commit_sha = commit_sha
        self.github_token = github_token
        self.region = region
        self.tag = tag
        self.cpu = cpu
        self.memory = memory

        self.script_path = os.path.join(os.path.dirname(__file__), '../../docker/gcp_execution.sh')
        self.machines_json = os.path.join(os.path.dirname(__file__), '../../resources/gcp_machines.json')

        self.machine_type = self.find_machine()

        super().__init__(model_path, prefix_params)


    def find_machine(self):
        machines = json.load(open(self.machines_json))

        optimal_machine = {'machine_type': None, 'price': float('inf')}

        for machine in machines:
            machine['cpu_count'] = float(machine['cpu_count'])
            machine['memory'] = float(machine['memory'])

            if machine['cpu_count'] >= self.cpu and machine['memory'] >= self.memory:
                price = GoogleCloudPlatform.CPU_COST_PER_HOUR * machine['cpu_count'] + \
                    GoogleCloudPlatform.MEMORY_COST_PER_HOUR * machine['memory']

                if price < optimal_machine['price']:
                    optimal_machine['machine_type'] = machine['machine_type']
                    optimal_machine['price'] = price

        return optimal_machine['machine_type']


    def train(self):
        command = ['sh', self.script_path, '-g', self.git_url, '-c', self.commit_sha,
            '-o', self.github_token, '-m', self.model_path, '-r', self.region,
            '-t', self.tag, '-n', self.machine_type, '-p', self.prefix_params]

        self.run_command(command)
        return 0


    def serve(self):
        pass
