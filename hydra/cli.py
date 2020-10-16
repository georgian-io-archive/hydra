import os
import click
from hydra.utils import *
from hydra.cloud.local_platform import LocalPlatform
from hydra.cloud.fast_local_platform import FastLocalPlatform
from hydra.cloud.google_cloud import GoogleCloud
from hydra.version import __version__

@click.group()
@click.version_option(__version__)
def cli():
    pass

@click.command()
@click.argument('name')
def hello(name):
   click.echo('Hello %s!' % name)

@cli.command()
# Generic options
@click.option('-m', '--model_path', required=True, type=str)
@click.option('--cloud', default='local', required=True, type=click.Choice(['fast_local','local', 'aws', 'gcp', 'azure'], case_sensitive=False))
@click.option('--github_token', envvar='GITHUB_TOKEN') # Takes either an option or environment var

# Cloud specific options
@click.option('--cpu', default=16, type=click.IntRange(0, 96), help='Number of CPU cores required')
@click.option('--memory', default=8, type=click.IntRange(0, 624), help='GB of RAM required')

@click.option('--gpu_count', default=0, type=click.IntRange(0, 8), help="Number of accelerator GPUs")
@click.option('--gpu_type', default='NVIDIA_TESLA_P4', type=str, help="Accelerator GPU type")

@click.option('--region', default='us-west2', type=str, help="Region of cloud server location")

# Docker Options
@click.option('-t', '--image_tag', default='', type=str, help="Docker image tag name")
@click.option('-u', '--image_url', default='', type=str, help="Url to the docker image on cloud")

# Env variable of model file
@click.option('-o', '--options', default='{}', type=str, help='Environmental variables for the script')

def train(
    model_path,
    cloud,
    github_token,
    cpu,
    memory,
    gpu_count,
    gpu_type,
    region,
    image_tag,
    image_url,
    options):

    prefix_params = json_to_string(options)

    if cloud == 'fast_local':

        platform = FastLocalPlatform(model_path, prefix_params)
        platform.train()
        return 0

    git_url, commit_sha = check_repo(github_token)

    if cloud == 'local':

        platform = LocalPlatform(model_path, prefix_params, git_url, commit_sha, github_token)

    elif cloud == 'gcp':

        platform = GoogleCloud(
            model_path=model_path,
            github_token=github_token,
            cpu=cpu,
            memory=memory,
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
