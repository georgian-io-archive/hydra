import os
import git
import json

def check_repo(github_token, branch):
    if github_token == None:
        raise Exception("GITHUB_TOKEN not found in environment variable or as argument")

    repo = git.Repo(os.getcwd())
    if (repo.bare):
        raise Exception("This is not a git repo")

    count_modified_files = len(repo.index.diff(None))
    count_staged_files = len(repo.index.diff("HEAD"))
    count_unpushed_commits = len(list(repo.iter_commits('master@{u}..master')))

    if count_unpushed_commits > 0:
        raise Exception("Some commits are not pushed to master branch.")

    if count_staged_files > 0:
        raise Exception("Some staged files are not commited.")

    if count_modified_files > 0:
        raise Exception("Some modified files are not staged for commit.")

def json_to_string(packet):
    dic = json.loads(packet)

    params = ""
    for key, value in dic.items():
        params += key + "=" + str(value) + " "

    return params.strip()
