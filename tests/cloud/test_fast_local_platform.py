import pytest
from hydra.cloud.fast_local_platform import *

MODEL_PATH = "deer/lake"
PREFIX_PARAMS = "epoch=88 lr=0.01"

def test_train_local(mocker):
    flp = FastLocalPlatform(MODEL_PATH, PREFIX_PARAMS)

    mocker.patch(
        'hydra.cloud.fast_local_platform.os.system',
    )

    result = flp.train()

    os.system.assert_called_once_with(" ".join([PREFIX_PARAMS, 'python3', MODEL_PATH]))

    assert result == 0
