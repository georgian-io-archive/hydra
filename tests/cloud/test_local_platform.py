import pytest
from hydra.cloud.local_platform import LocalPlatform

MODEL_PATH = "deer/lake"

GIT_URL = "https://github.com/georgianpartners/hydra"
COMMIT_SHA = "2012"
GITHUB_TOKEN = "201014w828"

OPTIONS = "epoch=88 lr=0.01"

SCRIPT_PATH = "camp/flog/gnaw"

@pytest.fixture
def local_platform():
    lp = LocalPlatform(
        model_path=MODEL_PATH,
        git_url=GIT_URL,
        commit_sha=COMMIT_SHA,
        github_token=GITHUB_TOKEN,
        options=OPTIONS
    )

    lp.script_path = SCRIPT_PATH

    yield lp


def test_train_local(mocker, local_platform):
    mocker.patch(
        'hydra.cloud.local_platform.LocalPlatform.run_command',
    )

    result = local_platform.train()

    local_platform.run_command.assert_called_once_with(['sh', SCRIPT_PATH, '-g', GIT_URL,
        '-c', COMMIT_SHA, '-o', GITHUB_TOKEN, '-m', MODEL_PATH, '-p', OPTIONS])

    assert result == 0
