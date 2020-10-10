import re
import os
import git
import json
import warnings
import subprocess
import OrderedDict
from hydra.git_repo import GitRepo


def json_to_string(packet):
    od = json.loads(packet, object_pairs_hook=OrderedDict)

    params = ""
    for key, value in od.items():
        params += key + "=" + str(value) + " "

    return params.strip()


def get_repo_url():
    git_url = subprocess.check_output("git config --get remote.origin.url", shell=True).decode("utf-8").strip()
    git_url = re.compile(r"https?://(www\.)?").sub("", git_url).strip().strip('/')
    return git_url


def get_commit_sha():
    commit_sha = subprocess.check_output("git log --pretty=tformat:'%h' -n1 .", shell=True).decode("utf-8").strip()
    return commit_sha


def check_repo(github_token, repo=None):
    if github_token == None:
        raise Exception("GITHUB_TOKEN not found in environment variable or as argument.")

    if repo is None:
        repo = git.Repo(os.getcwd())
        repo = GitRepo(repo)

    if repo.is_empty():
        raise Exception("Hydra is not being called in the root of a git repo.")

    if repo.is_untracked():
        warnings.warn("Some files are not tracked by git.", UserWarning)

    if repo.is_modified():
        raise Exception("Some modified files are not staged for commit.")

    if repo.is_uncommitted():
        raise Exception("Some staged files are not commited.")

    if repo.is_unsynced():
        raise Exception("Some commits are not pushed to the remote repo.")

    return 0
