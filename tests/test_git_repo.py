import pytest
import warnings
import pytest_mock
from hydra.git_repo import check_repo

VALID_GITHUB_TOKEN = "Georgian"

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
