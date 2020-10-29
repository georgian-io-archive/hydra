import pytest
import warnings
import pytest_mock
from hydra.utils.git_repo import *

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
