import pytest
import pytest_mock
from hydra.utils.storage import *

project_name = "your-project-name"
bucket_name = "your-bucket-name"
source_path = "storage-object-name"
destination_path = "file-name"

def test_get_gcp_dataset(mocker):
    mocker.patch(
        "hydra.utils.storage.storage.Client",
    )

    result = get_gcp_dataset(project_name, bucket_name, source_path, destination_path)
    assert result == 0


def test_save_gcp_result(mocker):
    mocker.patch(
        "hydra.utils.storage.storage.Client",
    )

    result = save_gcp_result(project_name, bucket_name, source_path, destination_path)
    assert result == 0


# def test_get_gcp_dataset_folder_does_not_exist(mocker):
#     mocker.patch(
#         "google.cloud.storage.Client",
#     )
#     mocker.patch(
#         "os.path.exists",
#         return_value=False
#     )
#     mocker.patch(
#         'os.makedirs'
#     )
#
#     result = get_gcp_dataset(project_name, bucket_name, source_path, destination_path)
#
#     os.makedirs.assert_called_once_with('data')
#
#     assert result == 0
#
#
# def test_get_gcp_dataset_file_exist(mocker):
#     mocker.patch(
#         "google.cloud.storage.Client",
#     )
#     mocker.patch(
#         "os.path.isfile",
#         return_value=True
#     )
#
#     result = get_gcp_dataset(project_name, bucket_name, source_path, destination_path)
#
#     assert result == 0
#
#
