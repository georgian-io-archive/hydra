from google.cloud import storage

def get_gcp_dataset(project_name, bucket_name, source_path, destination_path):
    # project_name = "your-project-name"
    # bucket_name = "your-bucket-name"
    # source_path = "storage-object-name"
    # destination_path = "local/path/to/file"

    client = storage.Client(project_name)
    bucket = client.get_bucket(bucket_name)

    bucket.get_blob(source_path).download_to_filename(destination_path)

    print("[PROJECT INFO] Blob {} downloaded to {}.".format(source_path, destination_path))

    return 0
