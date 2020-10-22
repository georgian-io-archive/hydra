import os
import argparse
import subprocess

args_parser = argparse.ArgumentParser()

args_parser.add_argument('--git_url',required=True)
args_parser.add_argument('--commit_sha',required=True)
args_parser.add_argument('--oauth_token',required=True)
args_parser.add_argument('--prefix_params')
args_parser.add_argument('--model_path',required=True)

args = args_parser.parse_args()

os.mkdir("project")
os.chdir("project")

subprocess.run(["git", "clone", "https://{}:x-oauth-basic@{}".format(args.oauth_token, args.git_url), "."])
subprocess.run(["git", "checkout", args.commit_sha])

subprocess.run(["conda", "env", "create", "-f", "environment.yml"])

# Temporary: Install hydra directly from github
subprocess.run(["git", "clone", "https://{}:x-oauth-basic@{}".format(args.oauth_token, "github.com/georgianpartners/hydra"), "hydra"])
subprocess.run(["git", "-C", "./hydra", "checkout", "5f1e82d"])
subprocess.run(["conda", "run", "-n", "hydra", "pip", "install", "-e", "hydra/"])

subprocess.run(["conda", "run", "-n", "hydra", "pip", "install", "mlflow"])

for arg in args.prefix_params.split():
    [key, val] = arg.split('=')
    os.putenv(key, val)

subprocess.run(["conda", "run", "-n", "hydra", "python3", args.model_path])
