import os
import click
from hydra.utils import *
from hydra.cloud.local_platform import LocalPlatform
from hydra.cloud.fast_local_platform import FastLocalPlatform
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
@click.option('-m', '--model_path', required=True, type=str)
@click.option('-c', '--cpu', default=16, type=click.IntRange(0, 128), help='Number of CPU cores required')
@click.option('-r', '--memory', default=8, type=click.IntRange(0, 128), help='GB of RAM required')
@click.option('--cloud', default='local', required=True, type=click.Choice(['fast_local','local', 'aws', 'gcp', 'azure'], case_sensitive=False))
@click.option('--github_token', envvar='GITHUB_TOKEN') # Takes either an option or environment var
@click.option('-o', '--options', default='{}', type=str)
def train(model_path, cpu, memory, github_token, cloud, options):
    prefix_params = json_to_string(options)

    if cloud == 'fast_local':
        platform = FastLocalPlatform(model_path, prefix_params)
        platform.train()

        return 0

    check_repo(github_token)
    git_url = get_repo_url()
    commit_sha = get_commit_sha()

    if cloud == 'local':
        platform = LocalPlatform(model_path, prefix_params, git_url, commit_sha, github_token)
        platform.train()

        return 0

    raise Exception("Reached parts of Hydra that are not yet implemented.")
