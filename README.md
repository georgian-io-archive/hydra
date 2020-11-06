# hydra
A cloud-agnostic Machine Learning Platform that will enable Data Scientists to run multiple experiments, perform hyper parameter optimization, evaluate results and serve models (batch/realtime) while still maintaining a uniform development UX across cloud environments 

## Installation
To install Hydra using PyPI, run the following command
```
$ pip install hydra-ml
```
To install Hydra using GitHub source, first clone Hydra using `git` :
```
$ git clone https://github.com/georgianpartners/hydra
```
Then in the `hydra` repository that you cloned, run
```
$ python setup.py install
```
Check the current hydra version by running
```
$ hydra --version
```

## Documentation

### Prerequisites

1. Github Token generation
    - Follow this guide : https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token
    - Add token to your enviroment variable by running 
    ```
    $ export GITHUB_TOKEN=<Fill your github token here>
    ```
2. Setting up your Cloud's CLI tool locally
    - GCP : https://cloud.google.com/sdk/gcloud
    - AWS : https://docs.aws.amazon.com/polly/latest/dg/setup-aws-cli.html
    - Azure : https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli
    
### Getting started

----------------------

#### `hydra`

Entrypoint for Hydra CLI

`hydra [flags]`

##### Examples

```
$ hydra --version
$ hydra --help
```

##### Options

```
  --version  Show hydra version
  --help     Show usage guide
```
----------------------

#### `hydra train`

Submit a training job to the selected cloud platform. You need to run this from inside a git hosted repository that
contains your model code and a conda yaml file `environment.yml` . The command takes a number of options to tailor your
training job. These options can also be provided via a `yaml` file 

`hydra train [flags]`

##### Examples

```
$ hydra train -m catboost_model.py --cloud gcp --cpu_count 8 --memory_size 20
$ hydra train -m catboost_model.py --cloud gcp --cpu_count 8 --memory_size 20 --options '{"iterations": 100, "depth": 20}'
$ hydra train -y catboost_model_configs.yaml
```

`catboost_model_configs.yaml` looks like this :
```
train:
  model_path: 'catboost_model.py'
  cloud: "gcp"
  cpu_count: 8
  memory_size: 16
  gpu_count: 1
  gpu_type: 'NVIDIA_TESLA_P4'
  region: 'us-west2'
  image_tag: 'batch'
  options:
    - project_name: "hydra-gcp-test-291317-aiplatform"
      bucket_name: "hydra-gcp-test-291317-aiplatform"
      blob_path: "hmnist/hmnist_64_64_L.csv"
      batch_size: 1
      epoch: 5
    - project_name: "hydra-gcp-test-291317-aiplatform"
      bucket_name: "hydra-gcp-test-291317-aiplatform"
      blob_path: "hmnist/hmnist_64_64_L.csv"
      batch_size: [1, 2, 3]
      epoch: [1, 2, 3]
```

##### Options

```
  -y, --yaml_path TEXT            Path to YAML file that contains preset options
  -m, --model_path TEXT           Path to file containing model code
  --cloud [fast_local|local|aws|gcp|azure]
  --github_token TEXT
  --cpu_count INTEGER RANGE       Number of CPU cores required
  --memory_size INTEGER RANGE     GB of RAM required
  --gpu_count INTEGER RANGE       Number of accelerator GPUs
  --gpu_type TEXT                 Accelerator GPU type
  --region TEXT                   Region of cloud server location
  -t, --image_tag TEXT            Docker image tag name
  -u, --image_url TEXT            Url to the docker image on cloud
  -o, --options TEXT              Environmental variables for the script

```

##### Options inherited from parent commands

```
  --help   Show usage guide for command
```
