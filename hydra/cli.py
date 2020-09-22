import click
from hydra.version import __version__


@click.group()
@click.version_option(__version__)
def cli():
    pass


@cli.command()
@click.option('--project_name')
@click.option('--model_name')
@click.option('--cpu')
@click.option('--memory')
@click.option('--options')
def train(project_name, model_name, cpu, memory, options):
    click.echo("This is the training command")
