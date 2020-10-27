import pytest
from hydra.cli import *
from click.testing import CliRunner

TEST_YAML_PATH = "tests/resources/test.yaml"

MODEL_PATH = "d3bug.py"
REPO_URL = "https://georgian.io/"
COMMIT_SHA = "m1rr0r1ng"
FILE_PATH = "ones/and/zer0es"
GITHUB_TOKEN =  "Georgian"
JSON_OPTIONS = "{'epoch': 88}"

CPU = 8
MEMORY = 16
GPU_TYPE = 'NVIDIA Tesla P4'
GPU_COUNT = 1
IMAGE_TAG = "default"
REGION = "us-west2"
OPTIONS = "epoch=88 lr=0.01"
SCRIPT_PATH = "camp/flog/gnaw"
MACHINE_NAME = "macbook-pro"

def test_train_local_cil(mocker):
    mocker.patch(
        "hydra.cli.os.path.isfile",
        return_value=False
    )
    mocker.patch(
        "hydra.cli.check_repo",
        return_value=(REPO_URL, COMMIT_SHA)
    )
    mocker.patch(
        "hydra.cli.json.loads",
    )
    mocker.patch(
        'hydra.cli.inflate_options',
        return_value=[JSON_OPTIONS]
    )
    mocker.patch(
        'hydra.cli.dict_to_string',
        return_value=OPTIONS
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
        ['--model_path', MODEL_PATH,
         '--cloud', 'local',
         '--github_token', GITHUB_TOKEN,
         '--options', JSON_OPTIONS])

    LocalPlatform.__init__.assert_called_once_with(
        model_path=MODEL_PATH,
        options=OPTIONS,
        git_url=REPO_URL,
        commit_sha=COMMIT_SHA,
        github_token=GITHUB_TOKEN,
    )

    LocalPlatform.train.assert_called_once_with()

    assert result.exit_code == 0



def test_train_google_cloud_cli(mocker):
    mocker.patch(
        "hydra.cli.os.path.isfile",
        return_value=False
    )
    mocker.patch(
        "hydra.cli.check_repo",
        return_value=(REPO_URL, COMMIT_SHA)
    )
    mocker.patch(
        "hydra.cli.json.loads",
    )
    mocker.patch(
        'hydra.cli.inflate_options',
        return_value=[JSON_OPTIONS]
    )
    mocker.patch(
        'hydra.cli.dict_to_string',
        return_value=OPTIONS
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
        ['--model_path', MODEL_PATH,
         '--cloud', 'gcp',
         '--github_token', GITHUB_TOKEN,
         '--cpu_count', CPU,
         '--memory_size', MEMORY,
         '--gpu_count', GPU_COUNT,
         '--gpu_type', GPU_TYPE,
         '--region', REGION,
         '--image_tag', IMAGE_TAG,
         '--options', JSON_OPTIONS])

    GoogleCloudPlatform.__init__.assert_called_once_with(
        model_path=MODEL_PATH,
        github_token=GITHUB_TOKEN,
        cpu=CPU,
        memory=MEMORY,
        gpu_count=GPU_COUNT,
        gpu_type=GPU_TYPE,
        region=REGION,
        git_url=REPO_URL,
        commit_sha=COMMIT_SHA,
        image_tag=IMAGE_TAG,
        image_url='',
        options=OPTIONS,
    )

    GoogleCloudPlatform.train.assert_called_once_with()

    assert result.exit_code == 0


def test_train_yaml(mocker):
    mocker.patch(
        "hydra.cli.os.path.isfile",
        return_value=True
    )
    mocker.patch(
        "hydra.cli.check_repo",
        return_value=(REPO_URL, COMMIT_SHA)
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
        ['-y', TEST_YAML_PATH,
        '--github_token', GITHUB_TOKEN])

    LocalPlatform.__init__.assert_has_calls(
        [
            mocker.call(
                model_path=MODEL_PATH,
                options='epoch=88 lr=0.01',
                git_url=REPO_URL,
                commit_sha=COMMIT_SHA,
                github_token=GITHUB_TOKEN,
            ),
            mocker.call(
                model_path=MODEL_PATH,
                options='epoch=88 lr=0.1',
                git_url=REPO_URL,
                commit_sha=COMMIT_SHA,
                github_token=GITHUB_TOKEN,
            ),
            mocker.call(
                model_path=MODEL_PATH,
                options='epoch=88 lr=1',
                git_url=REPO_URL,
                commit_sha=COMMIT_SHA,
                github_token=GITHUB_TOKEN,
            ),
            mocker.call(
                model_path=MODEL_PATH,
                options='epoch=888 lr=0.1',
                git_url=REPO_URL,
                commit_sha=COMMIT_SHA,
                github_token=GITHUB_TOKEN,
            ),
            mocker.call(
                model_path=MODEL_PATH,
                options='epoch=888 lr=1',
                git_url=REPO_URL,
                commit_sha=COMMIT_SHA,
                github_token=GITHUB_TOKEN,
            )
        ],
        any_order=True
    )



    LocalPlatform.train.assert_called_with()

    assert result.exit_code == 0
