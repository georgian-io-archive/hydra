import os
import shutil
import argparse
import subprocess

from hydra.utils.secrets import get_creds_for_gcp_mlflow

CONDA_ENV_NAME = "hydra"

args_parser = argparse.ArgumentParser()

args_parser.add_argument('--git_url', default=os.environ.get('HYDRA_GIT_URL'))
args_parser.add_argument('--commit_sha', default=os.environ.get('HYDRA_COMMIT_SHA'))
args_parser.add_argument('--oauth_token', default=os.environ.get('HYDRA_OAUTH_TOKEN'))
args_parser.add_argument('--options')
args_parser.add_argument('--model_path', default=os.environ.get('HYDRA_MODEL_PATH'))
args_parser.add_argument('--platform', default=os.environ.get('HYDRA_PLATFORM'))

args = args_parser.parse_args()

os.mkdir("project")
os.chdir("project")

# Clone and checkout the specified project repo from github
subprocess.run(["git", "clone", "https://{}:x-oauth-basic@{}".format(args.oauth_token, args.git_url), "."])
subprocess.run(["git", "checkout", args.commit_sha])

# Move data from tmp storage to project/data for local execution
if args.platform == 'local':
    if os.path.exists('/home/project/data'):
        shutil.rmtree('/home/project/data')
    shutil.copytree("/home/data", "/home/project/data")

subprocess.run(["conda", "env", "create", "-n", CONDA_ENV_NAME, "-f", "environment.yml"])
subprocess.run(["conda", "run", "-n", "hydra", "pip", "install", "hydra-ml==0.3.8"])

if args.options is not None:
    for arg in args.options.split():
        [key, val] = arg.split('=')
        os.putenv(key, val)

mlflow_tracking_uri, mlflow_username,\
    mlflow_pswd = "", "", ""

if os.environ.get('HYDRA_PLATFORM') == 'gcp':
    mlflow_tracking_uri, mlflow_username,\
    mlflow_pswd = get_creds_for_gcp_mlflow()

os.putenv('MLFLOW_TRACKING_URI', mlflow_tracking_uri)
os.putenv('MLFLOW_USERNAME', mlflow_username)
os.putenv('MLFLOW_PASSWORD', mlflow_pswd)

os.putenv('HYDRA_PLATFORM', args.platform)
os.putenv('HYDRA_GIT_URL', args.git_url)
os.putenv('HYDRA_COMMIT_SHA', args.commit_sha)
os.putenv('HYDRA_OAUTH_TOKEN', args.oauth_token)
os.putenv('HYDRA_MODEL_PATH', args.model_path)

subprocess.run(["conda", "run", "-n", CONDA_ENV_NAME, "python3", args.model_path])
