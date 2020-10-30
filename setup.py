import setuptools
from hydra.version import __version__


f = open('requirements.txt')
installation_requirements = f.read().split()

with open("README.md", "r") as fh:
    long_description = fh.read()

setuptools.setup(
    name="hydra-ml",
    version=__version__,
    author="Hydra Development Team",
    author_email="faisal.anees@georgian.io",
    description="A cloud-agnostic ML Platform",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/georgianpartners/hydra",
    py_modules=['hydra'],
    install_requires=installation_requirements,
    entry_points='''
        [console_scripts]
        hydra=hydra.cli:cli
    ''',
    packages=setuptools.find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: Apache Software License",
        "Operating System :: OS Independent",
        "Topic :: Scientific/Engineering :: Artificial Intelligence"
    ],
    python_requires='>=3.6',
)
