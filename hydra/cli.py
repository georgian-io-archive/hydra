import os
import re
import click
import subprocess
from hydra.utils import check_repo
from hydra.utils import json_to_string
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
        subprocess.run([prefix_params, 'python3', model_path])
        return 0

    check_repo(github_token)
    git_url = subprocess.check_output("git config --get remote.origin.url", shell=True).decode("utf-8").strip()
    # Remove https://www. prefix
    git_url = re.compile(r"https?://(www\.)?").sub("", git_url).strip().strip('/')
    commit_sha = subprocess.check_output("git log --pretty=tformat:'%h' -n1 .", shell=True).decode("utf-8").strip()

    if cloud == 'local':
        subprocess.run(
            ['sh', os.path.join(os.path.dirname(__file__), '../docker/local_execution.sh'),
             git_url, commit_sha, github_token, model_path, prefix_params])
        return 0

    raise Exception("Reached parts of Hydra that are not yet implemented.")
