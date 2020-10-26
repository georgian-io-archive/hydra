import pytest
from hydra.cli import *
from click.testing import CliRunner

VALID_MODEL_PATH = "d3bug.py"
VALID_REPO_URL = "https://georgian.io/"
VALID_COMMIT_SHA = "m1rr0r1ng"
VALID_FILE_PATH = "ones/and/zer0es"
VALID_GITHUB_TOKEN =  "Georgian"
VALID_OPTIONS = "{'epoch': 88}"

CPU = 8
MEMORY = 16
GPU_TYPE = 'NVIDIA Tesla P4'
GPU_COUNT = 1

IMAGE_TAG = "default"
IMAGE_URL = "snow/reggie.ie"

REGION = "us-west2"

OPTIONS = "epoch=88 lr=0.01"

SCRIPT_PATH = "camp/flog/gnaw"
MACHINE_NAME = "macbook-pro"

def test_train_local(mocker):
    def stub(dummy):
        pass

    mocker.patch(
        "hydra.cli.check_repo",
        return_value=(VALID_REPO_URL, VALID_COMMIT_SHA)
    )
    mocker.patch(
        "hydra.cli.os.path.join",
        return_value=VALID_FILE_PATH
    )
    mocker.patch(
        "hydra.cli.json_to_string",
        return_value=VALID_OPTIONS
    )

    mocker.patch(
        'hydra.cli.LocalPlatform.__init__',
        return_value=None
    )

    mocker.patch(
        'hydra.cli.LocalPlatform.train',
    )

    runner = CliRunner()
    result = runner.invoke(train,
        ['--model_path', VALID_MODEL_PATH,
         '--cloud', 'local',
         '--github_token', VALID_GITHUB_TOKEN,
         '--options', VALID_OPTIONS])

    LocalPlatform.__init__.assert_called_once_with(
        model_path=VALID_MODEL_PATH,
        options=VALID_OPTIONS,
        git_url=VALID_REPO_URL,
        commit_sha=VALID_COMMIT_SHA,
        github_token=VALID_GITHUB_TOKEN,
    )

    LocalPlatform.train.assert_called_once_with()

    assert result.exit_code == 0



def test_train_google_cloud(mocker):
    mocker.patch(
        "hydra.cli.check_repo",
        return_value=(VALID_REPO_URL, VALID_COMMIT_SHA)
    )
    mocker.patch(
        "hydra.cli.os.path.join",
        return_value=VALID_FILE_PATH
    )
    mocker.patch(
        "hydra.cli.json_to_string",
        return_value=VALID_OPTIONS
    )

    mocker.patch(
        'hydra.cli.GoogleCloudPlatform.__init__',
        return_value=None
    )

    mocker.patch(
        'hydra.cli.GoogleCloudPlatform.train'
    )

    runner = CliRunner()
    result = runner.invoke(train,
        ['--model_path', VALID_MODEL_PATH,
         '--cloud', 'gcp',
         '--github_token', VALID_GITHUB_TOKEN,
         '--cpu_count', CPU,
         '--memory_size', MEMORY,
         '--gpu_count', GPU_COUNT,
         '--gpu_type', GPU_TYPE,
         '--region', REGION,
         '--image_tag', IMAGE_TAG,
         '--image_url', IMAGE_URL,
         '--options', VALID_OPTIONS])

    GoogleCloudPlatform.__init__.assert_called_once_with(
        model_path=VALID_MODEL_PATH,
        github_token=VALID_GITHUB_TOKEN,
        cpu=CPU,
        memory=MEMORY,
        gpu_count=GPU_COUNT,
        gpu_type=GPU_TYPE,
        region=REGION,
        git_url=VALID_REPO_URL,
        commit_sha=VALID_COMMIT_SHA,
        image_url=IMAGE_URL,
        image_tag=IMAGE_TAG,
        options=VALID_OPTIONS,
    )

    GoogleCloudPlatform.train.assert_called_once_with()

    assert result.exit_code == 0
