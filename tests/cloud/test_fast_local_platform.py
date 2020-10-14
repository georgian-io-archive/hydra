import pytest
from hydra.cloud.fast_local_platform import *

MODEL_PATH = "deer/lake"
PREFIX_PARAMS = "epoch=88 lr=0.01"

def test_train_local(mocker):
    flp = FastLocalPlatform(MODEL_PATH, PREFIX_PARAMS)

    mocker.patch(
        'hydra.cloud.fast_local_platform.FastLocalPlatform.run_command',
    )

    result = flp.train()

    flp.run_command.assert_called_once_with([PREFIX_PARAMS, 'python3', MODEL_PATH])

    assert result == 0
