import pytest
import pytest_mock
from hydra.utils.utils import *

def test_dict_to_string():
    test_dict = {"depth":10, "epoch":100}
    result = dict_to_string(test_dict)

    assert result == "depth=10 epoch=100"
