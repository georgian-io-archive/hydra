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
