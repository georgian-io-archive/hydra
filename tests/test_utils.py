import pytest
from hydra.utils import *

def test_check_repo():
    with pytest.raises(Exception) as err:
        check_repo(None, "master")
    assert "GITHUB_TOKEN" in str(err.value)

def test_json_to_string():
    test_json = '{"depth":10, "epoch":100}'
    result = json_to_string(test_json)

    assert result == "depth=10 epoch=100"

def test_empty_json_to_string():
    test_json = '{}'
    result = json_to_string(test_json)

    assert result == ""
