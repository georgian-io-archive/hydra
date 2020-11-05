import os
import yaml
import json
import click
import hydra.utils.constants as const
from hydra.utils.git import check_repo
from hydra.utils.utils import dict_to_string, inflate_options
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
@click.option('-y', '--yaml_path', default='hydra.yaml', type=str)

@click.option('-m', '--model_path', default=None, type=str)
@click.option('--cloud', default=None, type=click.Choice(['fast_local','local', 'aws', 'gcp', 'azure'], case_sensitive=False))
@click.option('--github_token', envvar='GITHUB_TOKEN') # Takes either an option or environment var

# Cloud specific options
@click.option('--cpu_count', default=None, type=click.IntRange(0, 96), help='Number of CPU cores required')
@click.option('--memory_size', default=None, type=click.IntRange(0, 624), help='GB of RAM required')

@click.option('--gpu_count', default=None, type=click.IntRange(0, 8), help="Number of accelerator GPUs")
@click.option('--gpu_type', default=None, type=str, help="Accelerator GPU type")

@click.option('--region', default=None, type=str, help="Region of cloud server location")

# Docker Options
@click.option('-t', '--image_tag', default=None, type=str, help="Docker image tag name")
@click.option('-u', '--image_url', default=None, type=str, help="Url to the docker image on cloud")

# Env variable of model file
@click.option('-o', '--options', default=None, type=str, help='Environmental variables for the script')

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

    # If YAML config file available to supplement the command line arguments
    if os.path.isfile(yaml_path):
        with open(yaml_path) as f:
            print("[Hydra Info]: Loading run info from {}...".format(yaml_path))

            data = yaml.load(f, Loader=yaml.FullLoader)
            train_data = data.get('train', '')

            model_path = train_data.get('model_path', const.MODEL_PATH_DEFAULT) if model_path is None else model_path
            cloud = train_data.get('cloud', const.CLOUD_DEFAULT).lower() if cloud is None else cloud

            if cloud == 'gcp':
                region = train_data.get('region', const.REGION_DEFAULT) if region is None else region

                cpu_count = train_data.get('cpu_count', const.CPU_COUNT_DEFAULT) if cpu_count is None else cpu_count
                memory_size = train_data.get('memory_size', const.MEMORY_SIZE_DEFAULT) if memory_size is None else memory_size
                gpu_count = train_data.get('gpu_count', const.GPU_COUNT_DEFAULT) if gpu_count is None else gpu_count
                gpu_type = train_data.get('gpu_type', const.GPU_TYPE_DEFAULT) if gpu_type is None else gpu_type

                image_tag = train_data.get('image_tag', const.IMAGE_TAG_DEFAULT) if image_tag is None else image_tag
                image_url = train_data.get('image_url', const.IMAGE_URL_DEFAULT) if image_url is None else image_url

            elif cloud == 'local' or cloud == 'fast_local':
                pass

            else:
                raise Exception("Reached parts of Hydra that are either not implemented or recognized.")

            options_list = train_data.get('options', const.OPTIONS_DEFAULT) if options is None else options
    # Read the options for run from CIL
    else:
        model_path = const.MODEL_PATH_DEFAULT if model_path is None else model_path
        cloud = const.CLOUD_DEFAULT if cloud is None else cloud

        region = const.REGION_DEFAULT if region is None else region

        cpu_count = const.CPU_COUNT_DEFAULT if cpu_count is None else cpu_count
        memory_size = const.MEMORY_SIZE_DEFAULT if memory_size is None else memory_size
        gpu_count = const.GPU_COUNT_DEFAULT if gpu_count is None else gpu_count
        gpu_type = const.GPU_TYPE_DEFAULT if gpu_type is None else gpu_type

        image_tag = const.IMAGE_TAG_DEFAULT if image_tag is None else image_tag
        image_url = const.IMAGE_URL_DEFAULT if image_url is None else image_url

        options = const.OPTIONS_DEFAULT if options is None else options
        options_list = json.loads(options)

    if isinstance(options_list, dict):
        options_list = [options_list]

    options_list_inflated = inflate_options(options_list)

    print("\n[Hydra Info]: Executing experiments with the following options: \n {}\n".format(options_list_inflated))

    for i, options in enumerate(options_list_inflated):
        options = dict_to_string(options)

        print("\n[Hydra Info]: Runnning experiment #{} with the following options: \n {}\n".format(i, options))

        if cloud == 'fast_local':

            platform = FastLocalPlatform(model_path, options)
            platform.train()
            continue

        git_url, commit_sha = check_repo(github_token)

        if cloud == 'local':

            platform = LocalPlatform(
                model_path=model_path,
                options=options,
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
                options=options)

        else:
            raise Exception("Reached parts of Hydra that are not yet implemented.")

        platform.train()

    return 0
