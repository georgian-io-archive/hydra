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
CPU = 8
MEMORY = 16

@pytest.fixture
def google_cloud_platform():
    gcp = GoogleCloud(
        MODEL_PATH,
        PREFIX_PARAMS,
        GIT_URL,
        COMMIT_SHA,
        GITHUB_TOKEN,
        TAG,
        CPU,
        MEMORY,
        REGION
    )

    gcp.script_path = SCRIPT_PATH

    yield gcp


def test_train_local(mocker, google_cloud_platform):
    mocker.patch(
        'hydra.cloud.google_cloud.GoogleCloud.run_command',
    )

    result = google_cloud_platform.train()

    google_cloud_platform.run_command.assert_called_once_with(['sh', SCRIPT_PATH, '-g', GIT_URL,
        '-c', COMMIT_SHA, '-o', GITHUB_TOKEN, '-m', MODEL_PATH,
        '-r', REGION, '-t', TAG, '-p', PREFIX_PARAMS])

    assert result == 0


def test_find_machine(mocker, google_cloud_platform):
    google_cloud_platform.cpu = 32
    google_cloud_platform.memory = 28.8

    result = google_cloud_platform.find_machine()

    assert result == "n1-highcpu-32"
