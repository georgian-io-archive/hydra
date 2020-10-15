import pytest
from hydra.cloud.google_cloud import *

MODEL_PATH = "deer/lake"
PREFIX_PARAMS = "epoch=88 lr=0.01"
GIT_URL = "https://github.com/georgianpartners/hydra"
COMMIT_SHA = "2012"
GITHUB_TOKEN = "201014w828"
TAG = "default"
REGION = "us-west2"
SCRIPT_PATH = "camp/flog/gnaw"

def test_train_local(mocker):
    gcp = GoogleCloud(
        MODEL_PATH, PREFIX_PARAMS, GIT_URL, COMMIT_SHA, GITHUB_TOKEN, TAG, REGION
    )
    gcp.script_path = SCRIPT_PATH

    mocker.patch(
        'hydra.cloud.google_cloud.GoogleCloud.run_command',
    )

    result = gcp.train()

    gcp.run_command.assert_called_once_with(['sh', SCRIPT_PATH, '-g', GIT_URL,
        '-c', COMMIT_SHA, '-o', GITHUB_TOKEN, '-m', MODEL_PATH,
        '-r', REGION, '-t', TAG, '-p', PREFIX_PARAMS])

    assert result == 0
