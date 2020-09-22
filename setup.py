from setuptools import setup
from hydra.version import __version__


f = open('requirements.txt')
installation_requirements = f.read().split()

setup(
    name="hydra",
    version=__version__,
    py_modules=['hydra'],
    install_requires=installation_requirements,
    entry_points='''
        [console_scripts]
        hydra=hydra.cli:cli
    ''',
)
