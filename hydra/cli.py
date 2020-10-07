import os
import re
import git
import click
import subprocess
from hydra.version import __version__

@click.group()
@click.version_option(__version__)
def cli():
    pass


@cli.command()
@click.option('-m', '--model_path', required=True, type=str)
@click.option('-c', '--cpu', default=16, type=click.IntRange(0, 128), help='Number of CPU cores required')
@click.option('-r', '--memory', default=8, type=click.IntRange(0, 128), help='GB of RAM required')
@click.option('--cloud', default='local', type=click.Choice(['local', 'aws', 'gcp', 'azure'], case_sensitive=False))
@click.option('--github_token', envvar='GITHUB_TOKEN') # Takes either an option or environment var
@click.option('-b', '--branch', default='master', type=str)

def train(model_path, cpu, memory, github_token, cloud, branch):
    click.echo("This is the training command")
    click.echo("Running on {}".format(cloud))
    click.echo("Remote branch: {}".format(branch))

    if github_token == "":
        raise Exception("GITHUB_TOKEN not found in environment variable or as argument")

    repo = git.Repo(os.getcwd())
    if (repo.bare):
        raise Exception("This is not a git repo")

    count_modified_files = len(repo.index.diff(None))
    count_staged_files = len(repo.index.diff("HEAD"))
    count_unpushed_commits = len(list(repo.iter_commits(branch+'@{u}..master')))

    if count_unpushed_commits > 0:
        raise Exception("Some commits are not pushed to master branch.")

    if count_staged_files > 0:
        raise Exception("Some staged files are not commited.")

    if count_modified_files > 0:
        raise Exception("Some modified files are not staged for commit.")

    git_url = subprocess.check_output("git config --get remote.origin.url", shell=True).decode("utf-8").strip()
    # Remove https://www. prefix
    git_url = re.compile(r"https?://(www\.)?").sub("", git_url).strip().strip('/')
    commit_sha = subprocess.check_output("git log --pretty=tformat:'%h' -n1 .", shell=True).decode("utf-8").strip()

    if cloud == 'local':
        subprocess.run(
            ['sh', os.path.join(os.path.dirname(__file__), '../docker/local_execution.sh'), git_url, commit_sha, model_path, github_token])
