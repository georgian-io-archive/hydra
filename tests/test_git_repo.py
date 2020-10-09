import pytest
import warnings
import pytest_mock
from hydra.git_repo import *

VALID_GITHUB_TOKEN = "Georgian"
VALID_MULTIPLE_FILES = ["shopify.inc", "clickup.tm"]
VALID_MULTIPLE_COMMITS = ["m1rr0r1ng"]
VALID_BRANCH_NAME = "bay3s1an"

def test_GitRepo_is_empty_true(mocker):
    repo = mocker.Mock()
    repo.bare = True

    git_repo = GitRepo(repo)
    result = git_repo.is_empty()

    assert result == True


def test_GitRepo_is_empty_false(mocker):
    repo = mocker.Mock()
    repo.bare = False

    git_repo = GitRepo(repo)
    result = git_repo.is_empty()

    assert result == False


def test_GitRepo_is_untracked_true(mocker):
    repo = mocker.Mock()
    repo.untracked_files = VALID_MULTIPLE_FILES

    git_repo = GitRepo(repo)
    result = git_repo.is_untracked()

    assert result == True


def test_GitRepo_is_untracked_false(mocker):
    repo = mocker.Mock()
    repo.untracked_files = []

    git_repo = GitRepo(repo)
    result = git_repo.is_untracked()

    assert result == False


def test_GitRepo_is_modified_true(mocker):
    repo = mocker.Mock()
    repo.index.diff.return_value = VALID_MULTIPLE_COMMITS

    git_repo = GitRepo(repo)
    result = git_repo.is_modified()

    repo.index.diff.assert_called_once_with(None)
    assert result == True


def test_GitRepo_is_modified_false(mocker):
    repo = mocker.Mock()
    repo.index.diff.return_value = []

    git_repo = GitRepo(repo)
    result = git_repo.is_modified()

    repo.index.diff.assert_called_once_with(None)
    assert result == False


def test_GitRepo_is_uncommitted_true(mocker):
    repo = mocker.Mock()
    repo.index.diff.return_value = VALID_MULTIPLE_COMMITS

    git_repo = GitRepo(repo)
    result = git_repo.is_uncommitted()

    repo.index.diff.assert_called_once_with("HEAD")
    assert result == True


def test_GitRepo_is_uncommitted_false(mocker):
    repo = mocker.Mock()
    repo.index.diff.return_value = []

    git_repo = GitRepo(repo)
    result = git_repo.is_uncommitted()

    repo.index.diff.assert_called_once_with("HEAD")
    assert result == False


def test_GitRepo_is_unsynced_true(mocker):
    repo = mocker.Mock()
    repo.active_branch.name = VALID_BRANCH_NAME
    repo.iter_commits.return_value = VALID_MULTIPLE_COMMITS

    git_repo = GitRepo(repo)
    result = git_repo.is_unsynced()

    repo.iter_commits.assert_called_once_with('origin/{}..{}'.format(VALID_BRANCH_NAME, VALID_BRANCH_NAME))
    assert result == True


def test_GitRepo_is_unsynced_false(mocker):
    repo = mocker.Mock()
    repo.active_branch.name = VALID_BRANCH_NAME
    repo.iter_commits.return_value = []

    git_repo = GitRepo(repo)
    result = git_repo.is_unsynced()

    repo.iter_commits.assert_called_once_with('origin/{}..{}'.format(VALID_BRANCH_NAME, VALID_BRANCH_NAME))
    assert result == False


def test_check_repo_success(mocker):
    def pass_test(self):
        return False
    def fail_test(self):
        return True

    mocker.patch(
        "hydra.git_repo.GitRepo.is_empty",
        pass_test
    )
    mocker.patch(
        "hydra.git_repo.GitRepo.is_untracked",
        pass_test
    )
    mocker.patch(
        "hydra.git_repo.GitRepo.is_modified",
        pass_test
    )
    mocker.patch(
        "hydra.git_repo.GitRepo.is_uncommitted",
        pass_test
    )
    mocker.patch(
        "hydra.git_repo.GitRepo.is_unsynced",
        pass_test
    )

    result = check_repo(VALID_GITHUB_TOKEN)
    assert result == 0


def test_check_repo_empty_token():
    with pytest.raises(Exception) as err:
        check_repo(None)
    assert "GITHUB_TOKEN" in str(err.value)


def test_check_repo_untracked(mocker):
    def pass_test(self):
        return False
    def fail_test(self):
        return True

    with pytest.raises(Exception) as err:

        mocker.patch(
            "hydra.git_repo.GitRepo.is_empty",
            fail_test
        )
        mocker.patch(
            "hydra.git_repo.GitRepo.is_untracked",
            pass_test
        )
        mocker.patch(
            "hydra.git_repo.GitRepo.is_modified",
            pass_test
        )
        mocker.patch(
            "hydra.git_repo.GitRepo.is_uncommitted",
            pass_test
        )
        mocker.patch(
            "hydra.git_repo.GitRepo.is_unsynced",
            pass_test
        )

        check_repo(VALID_GITHUB_TOKEN)

    assert "Hydra is not being called in the root of a git repo." == str(err.value)


def test_check_repo_modified(mocker):
    def pass_test(self):
        return False
    def fail_test(self):
        return True

    with pytest.raises(Exception) as err:

        mocker.patch(
            "hydra.git_repo.GitRepo.is_empty",
            pass_test
        )
        mocker.patch(
            "hydra.git_repo.GitRepo.is_untracked",
            pass_test
        )
        mocker.patch(
            "hydra.git_repo.GitRepo.is_modified",
            fail_test
        )
        mocker.patch(
            "hydra.git_repo.GitRepo.is_uncommitted",
            pass_test
        )
        mocker.patch(
            "hydra.git_repo.GitRepo.is_unsynced",
            pass_test
        )

        check_repo(VALID_GITHUB_TOKEN)

    assert "Some modified files are not staged for commit." == str(err.value)


def test_check_repo_uncommitted(mocker):
    def pass_test(self):
        return False
    def fail_test(self):
        return True

    with pytest.raises(Exception) as err:

        mocker.patch(
            "hydra.git_repo.GitRepo.is_empty",
            pass_test
        )
        mocker.patch(
            "hydra.git_repo.GitRepo.is_untracked",
            pass_test
        )
        mocker.patch(
            "hydra.git_repo.GitRepo.is_modified",
            pass_test
        )
        mocker.patch(
            "hydra.git_repo.GitRepo.is_uncommitted",
            fail_test
        )
        mocker.patch(
            "hydra.git_repo.GitRepo.is_unsynced",
            pass_test
        )

        check_repo(VALID_GITHUB_TOKEN)

    assert "Some staged files are not commited." == str(err.value)


def test_check_repo_unsynced(mocker):
    def pass_test(self):
        return False
    def fail_test(self):
        return True

    with pytest.raises(Exception) as err:

        mocker.patch(
            "hydra.git_repo.GitRepo.is_empty",
            pass_test
        )
        mocker.patch(
            "hydra.git_repo.GitRepo.is_untracked",
            pass_test
        )
        mocker.patch(
            "hydra.git_repo.GitRepo.is_modified",
            pass_test
        )
        mocker.patch(
            "hydra.git_repo.GitRepo.is_uncommitted",
            pass_test
        )
        mocker.patch(
            "hydra.git_repo.GitRepo.is_unsynced",
            fail_test
        )

        check_repo(VALID_GITHUB_TOKEN)

    assert "Some commits are not pushed to the remote repo."== str(err.value)


def test_check_repo_untracked(mocker):
    def pass_test(self):
        return False
    def fail_test(self):
        return True

    with pytest.warns(UserWarning) as record:

        mocker.patch(
            "hydra.git_repo.GitRepo.is_empty",
            pass_test
        )
        mocker.patch(
            "hydra.git_repo.GitRepo.is_untracked",
            fail_test
        )
        mocker.patch(
            "hydra.git_repo.GitRepo.is_modified",
            pass_test
        )
        mocker.patch(
            "hydra.git_repo.GitRepo.is_uncommitted",
            pass_test
        )
        mocker.patch(
            "hydra.git_repo.GitRepo.is_unsynced",
            pass_test
        )

        check_repo(VALID_GITHUB_TOKEN)

    assert "Some files are not tracked by git." == record[0].message.args[0]
