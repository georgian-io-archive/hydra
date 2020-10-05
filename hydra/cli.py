import click
import subprocess
from hydra.version import __version__

@click.group()
@click.version_option(__version__)
def cli():
    pass


@cli.command()
@click.option('-p', '--project_name', required=True, type=str)
@click.option('-c', '--cpu', default=16, type=click.IntRange(0, 128), help='Number of CPU cores required')
@click.option('-r', '--memory', default=8, type=click.IntRange(0, 128), help='GB of RAM required')
@click.option('--cloud', default='local', type=click.Choice(['local', 'aws', 'gcp', 'azure'], case_sensitive=False))
@click.option('--github_token', envvar='GITHUB_TOKEN') # Takes either an option or environment var

def train(project_name, cpu, memory, github_token, cloud):
    click.echo("This is the training command")
    click.echo(f"Running on {cloud}.")

    if cloud == 'local':
        subprocess.run(['sh', 'docker/local_execution.sh', project_name, github_token])
