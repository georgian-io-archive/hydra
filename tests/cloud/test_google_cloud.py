import pytest
from hydra.cloud.google_cloud import GoogleCloud

MODEL_PATH = "deer/lake"
PREFIX_PARAMS = "epoch=88 lr=0.01"
GIT_URL = "https://github.com/georgianpartners/hydra"
COMMIT_SHA = "2012"
GITHUB_TOKEN = "201014w828"
TAG = "default"
REGION = "us-west2"

def test_train_local(mocker):
    gcp = GoogleCloud(
        MODEL_PATH, PREFIX_PARAMS, GIT_URL, COMMIT_SHA, GITHUB_TOKEN, TAG, REGION
    )

    mocker.patch(
        'hydra.cli.subprocess.run',
    )

    subprocess.run.assert_called_once_with(
        ['sh', VALID_FILE_PATH,
        VALID_REPO_URL, VALID_COMMIT_SHA, VALID_GITHUB_TOKEN,
        VALID_MODEL_PATH, VALID_PREFIX_PARAMS])

    assert result.exit_code == 0
