import os
import shutil
import argparse
import subprocess

CONDA_ENV_NAME = "hydra"

args_parser = argparse.ArgumentParser()

args_parser.add_argument('--git_url', default=os.environ.get('HYDRA_GIT_URL'))
args_parser.add_argument('--commit_sha', default=os.environ.get('HYDRA_COMMIT_SHA'))
args_parser.add_argument('--oauth_token', default=os.environ.get('HYDRA_OAUTH_TOKEN'))
args_parser.add_argument('--options')
args_parser.add_argument('--model_path', default=os.environ.get('HYDRA_MODEL_PATH'))
args_parser.add_argument('--platform', default=os.environ.get('HYDRA_PLATFORM'))
args_parser.add_argument('--code_dump_uri', default=os.environ.get('HYDRA_CODE_DUMP_URI'))

args = args_parser.parse_args()

os.mkdir("project")
os.chdir("project")

# Clone and checkout the specified project repo from github
if args.code_dump_uri is None:
    subprocess.run(["git", "clone", "https://{}:x-oauth-basic@{}".format(args.oauth_token, args.git_url), "."])
    subprocess.run(["git", "checkout", args.commit_sha])
else:
    subprocess.run(f'aws s3 cp --recursive {args.code_dump_uri} .')

# Move data from tmp storage to project/data for local execution
if args.platform == 'local':
    if os.path.exists('/home/project/data'):
        shutil.rmtree('/home/project/data')
    shutil.copytree("/home/data", "/home/project/data")

subprocess.run(["conda", "env", "create", "-n", CONDA_ENV_NAME, "-f", "environment.yml"])
subprocess.run(["conda", "run", "-n", "hydra", "pip", "install", "hydra-ml"])

if args.options is not None:
    for arg in args.options.split():
        [key, val] = arg.split('=')
        os.putenv(key, val)

os.putenv('HYDRA_PLATFORM', args.platform)
os.putenv('HYDRA_GIT_URL', args.git_url)
os.putenv('HYDRA_COMMIT_SHA', args.commit_sha)
os.putenv('HYDRA_OAUTH_TOKEN', args.oauth_token)
os.putenv('HYDRA_MODEL_PATH', args.model_path)

subprocess.run(["conda", "run", "-n", CONDA_ENV_NAME, "python3", args.model_path])
