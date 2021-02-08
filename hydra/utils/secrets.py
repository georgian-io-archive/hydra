import os

from google.cloud import secretmanager

def access_secret_version(project_id, secret_id, version_id="latest"):
    # Create the Secret Manager client.
    client = secretmanager.SecretManagerServiceClient()

    # Build the resource name of the secret version.
    name = f"projects/{project_id}/secrets/{secret_id}/versions/{version_id}"

    # Access the secret version.
    response = client.access_secret_version(name=name)

    # Return the decoded payload.
    return response.payload.data.decode('UTF-8')


def get_creds_for_gcp_mlflow():
    project_id = os.environ["GCP_PROJECT"]

    tracking_uri = access_secret_version(project_id, 'MLFLOW_TRACKING_URI')
    username = access_secret_version(project_id, 'MLFLOW_TRACKING_USERNAME')
    pswd = access_secret_version(project_id, 'MLFLOW_TRACKING_PASSWORD')
    return tracking_uri, username, pswd
