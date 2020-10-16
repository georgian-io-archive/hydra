import pytest
from hydra.cloud.google_cloud import *

MODEL_PATH = "deer/lake"

GIT_URL = "https://github.com/georgianpartners/hydra"
COMMIT_SHA = "2012"
GITHUB_TOKEN = "201014w828"

CPU = 8
MEMORY = 16
GPU_TYPE = 'NVIDIA Tesla P4'
GPU_COUNT = "1"

IMAGE_TAG = "default"
IMAGE_URI = "snow/reggie.ie"

REGION = "us-west2"

PREFIX_PARAMS = "epoch=88 lr=0.01"

SCRIPT_PATH = "camp/flog/gnaw"
MACHINE_NAME = "macbook-pro"


@pytest.fixture
def google_cloud_platform():
    gcp = GoogleCloud(
        model_path=MODEL_PATH,
        git_url=GIT_URL,
        commit_sha=COMMIT_SHA,
        github_token=GITHUB_TOKEN,
        cpu=CPU,
        memory=MEMORY,
        gpu_type=GPU_TYPE,
        gpu_count=GPU_COUNT,
        image_tag=IMAGE_TAG,
        image_url=IMAGE_URI,
        region=REGION,
        prefix_params=PREFIX_PARAMS
    )

    gcp.script_path = SCRIPT_PATH
    gcp.machine_type = MACHINE_NAME

    yield gcp


def test_train_local(mocker, google_cloud_platform):
    mocker.patch(
        'hydra.cloud.google_cloud.GoogleCloud.run_command',
    )

    result = google_cloud_platform.train()

    google_cloud_platform.run_command.assert_called_once_with(['sh', SCRIPT_PATH, '-g', GIT_URL,
        '-c', COMMIT_SHA, '-o', GITHUB_TOKEN, '-m', MODEL_PATH, '-r', REGION,
        '-t', IMAGE_TAG, '-u', IMAGE_URI, '-a', GPU_COUNT, '-y', GPU_TYPE,
        '-n', MACHINE_NAME, '-p', PREFIX_PARAMS])

    assert result == 0


def test_find_machine(mocker, google_cloud_platform):
    google_cloud_platform.cpu = 32
    google_cloud_platform.memory = 28.8

    result = google_cloud_platform.find_machine()

    assert result == "n1-highcpu-32"
