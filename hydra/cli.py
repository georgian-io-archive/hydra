import os
import yaml
import click
from hydra.utils.constants import *
from hydra.utils.git import check_repo
from hydra.utils.utils import json_to_string
from hydra.cloud.local_platform import LocalPlatform
from hydra.cloud.fast_local_platform import FastLocalPlatform
from hydra.cloud.google_cloud_platform import GoogleCloudPlatform
from hydra.version import __version__

@click.group()
@click.version_option(__version__)
def cli():
    pass


@cli.command()
# Generic options
@click.option('-y', '--yaml_path', default=None, type=str)

@click.option('-m', '--model_path', default=MODEL_PATH_DEFAULT, type=str)
@click.option('--cloud', default='local', type=click.Choice(['fast_local','local', 'aws', 'gcp', 'azure'], case_sensitive=False))
@click.option('--github_token', envvar='GITHUB_TOKEN') # Takes either an option or environment var

# Cloud specific options
@click.option('--cpu_count', default=16, type=click.IntRange(0, 96), help='Number of CPU cores required')
@click.option('--memory_size', default=8, type=click.IntRange(0, 624), help='GB of RAM required')

@click.option('--gpu_count', default=0, type=click.IntRange(0, 8), help="Number of accelerator GPUs")
@click.option('--gpu_type', default='NVIDIA_TESLA_P4', type=str, help="Accelerator GPU type")

@click.option('--region', default='us-west2', type=str, help="Region of cloud server location")

# Docker Options
@click.option('-t', '--image_tag', default='main', type=str, help="Docker image tag name")
@click.option('-u', '--image_url', default='', type=str, help="Url to the docker image on cloud")

# Env variable of model file
@click.option('-o', '--options', default='{}', type=str, help='Environmental variables for the script')

def train(
    yaml_path,
    model_path,
    cloud,
    github_token,
    cpu_count,
    memory_size,
    gpu_count,
    gpu_type,
    region,
    image_tag,
    image_url,
    options):

    if os.path.isfile(yaml_path):
        with open(yaml_path) as f:
            data = yaml.load(f, Loader=yaml.FullLoader)

            model_path = data['entry_point']
            platform = data['platform']

            if platform['provider'] in ['gcp', 'GCP']:
                cloud = 'gcp'
                region = platform.get('region', 'us-west2')

                cpu_count = platform.get('cpu_count', 8)
                memory_size = platform.get('memory_size', 8)
                gpu_count = platform['gpu_count']
                gpu_type = platform['gpu_type']

                image_tag = data.['docker_image'].get('tag')
                image_url = data.['docker_image'].get('url')

            elif platform['provider'] in ['local', 'Local']:
                cloud = 'local'

            elif platform['provider'] == 'fast_local':
                cloud = 'fast_local'

            else:
                raise Exception("Reached parts of Hydra that are either not implemented or recognized.")

            options = data['env_vars']


    prefix_params = json_to_string(options)

    if cloud == 'fast_local':

        platform = FastLocalPlatform(model_path, prefix_params)
        platform.train()
        return 0

    git_url, commit_sha = check_repo(github_token)

    if cloud == 'local':

        platform = LocalPlatform(
            model_path=model_path,
            prefix_params=prefix_params,
            git_url=git_url,
            commit_sha=commit_sha,
            github_token=github_token)

    elif cloud == 'gcp':

        platform = GoogleCloudPlatform(
            model_path=model_path,
            github_token=github_token,
            cpu=cpu_count,
            memory=memory_size,
            gpu_count=gpu_count,
            gpu_type=gpu_type,
            region=region,
            git_url=git_url,
            commit_sha=commit_sha,
            image_url=image_url,
            image_tag=image_tag,
            prefix_params=prefix_params)

    else:
        raise Exception("Reached parts of Hydra that are not yet implemented.")

    platform.train()

    return 0
