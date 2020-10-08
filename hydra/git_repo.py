import os
import git
import warnings

class GitRepo():
    def __init__(self, repo):
        self.repo = repo

    def is_empty(self):
        return self.repo.bare

    def is_untracked(self):
        return len(self.repo.untracked_files) > 0

    def is_modified(self):
        return len(self.repo.index.diff(None)) > 0

    def is_uncommitted(self):
        return len(self.repo.index.diff("HEAD")) > 0

    def is_unsynced(self):
        branch_name = self.repo.active_branch.name
        count_unpushed_commits = len(list(self.repo.iter_commits('origin/{}..{}'.format(branch_name, branch_name))))
        return count_unpushed_commits > 0

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
