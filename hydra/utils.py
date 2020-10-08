import os
import git
import json
import warnings

def check_repo(github_token):
    if github_token == None:
        raise Exception("GITHUB_TOKEN not found in environment variable or as argument")

    repo = git.Repo(os.getcwd())
    if (repo.bare):
        raise Exception("This is not a git repo")

    if len(repo.untracked_files) > 0:
        warnings.warn('Following files are not tracked by git: ')
        print(repo.untracked_files)

    count_modified_files = len(repo.index.diff(None))
    if count_modified_files > 0:
        raise Exception("Some modified files are not staged for commit.")

    count_staged_files = len(repo.index.diff("HEAD"))
    if count_staged_files > 0:
        raise Exception("Some staged files are not commited.")

    branch_name = repo.active_branch.name
    count_unpushed_commits = len(list(repo.iter_commits('origin/{}..{}'.format(branch_name, branch_name))))
    if count_unpushed_commits > 0:
        raise Exception("Some commits are not pushed to master branch.")

    return 0

def json_to_string(packet):
    dic = json.loads(packet)

    params = ""
    for key, value in dic.items():
        params += key + "=" + str(value) + " "

    return params.strip()
