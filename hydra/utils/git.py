import re
import os
import git
import warnings
import subprocess
from hydra.utils.git_repo import GitRepo


def get_repo_url():
    git_url = subprocess.check_output("git config --get remote.origin.url", shell=True).decode("utf-8").strip()
    git_url = re.compile(r"https?://(www\.)?").sub("", git_url).strip().strip('/')
    if len(git_url.split(":")) > 1:
        git_url = git_url.split(":")[-1]
        git_url = f"github.com/{git_url}"
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

    repo_url = get_repo_url()
    commit_sha = get_commit_sha()

    return repo_url, commit_sha
