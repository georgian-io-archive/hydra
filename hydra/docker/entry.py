import os
import shutil
import argparse
import subprocess
import boto3
import os
import mysql.connector

CONDA_ENV_NAME = "hydra"
HYDRA_METADATA_JOB_TYPES = {
    'unknown': 1,
    'experiment': 2,
    'job': 3,
    'jobset': 4
}

args_parser = argparse.ArgumentParser()

args_parser.add_argument('--git_url', default=os.environ.get('HYDRA_GIT_URL'))
args_parser.add_argument('--commit_sha', default=os.environ.get('HYDRA_COMMIT_SHA'))
args_parser.add_argument('--oauth_token', default=os.environ.get('HYDRA_OAUTH_TOKEN'))
args_parser.add_argument('--options')
args_parser.add_argument('--model_path', default=os.environ.get('HYDRA_MODEL_PATH'))
args_parser.add_argument('--platform', default=os.environ.get('HYDRA_PLATFORM'))
args_parser.add_argument('--code_dump_uri', default=os.environ.get('HYDRA_CODE_DUMP_URI'))

args_parser.add_argument('--db_hostname', default=os.environ.get('HYDRA_METADATA_DB_HOSTNAME'))
args_parser.add_argument('--db_username_secret', default=os.environ.get('HYDRA_METADATA_DB_USERNAME_SECRET'))
args_parser.add_argument('--db_password_secret', default=os.environ.get('HYDRA_METADATA_DB_PASSWORD_SECRET'))
args_parser.add_argument('--db_name', default=os.environ.get('HYDRA_METADATA_DB_NAME'))

args_parser.add_argument('--job_uuid', default=os.environ.get('ATTRIBUTE_JOB_UUID'))
args_parser.add_argument('--job_name', default=os.environ.get('ATTRIBUTE_JOB_NAME'))
args_parser.add_argument('--job_location', default=os.environ.get('ATTRIBUTE_JOB_LOCATION'))
args_parser.add_argument('--username', default=os.environ.get('ATTRIBUTE_USERNAME'))
args_parser.add_argument('--ip_address', default=os.environ.get('ATTRIBUTE_IP_ADDRESS'))
args_parser.add_argument('--image_uri', default=os.environ.get('ATTRIBUTE_IMAGE_URI'))
args_parser.add_argument('--hydra_version', default=os.environ.get('ATTRIBUTE_HYDRA_VERSION'))

args = args_parser.parse_args()

os.mkdir("project")
os.chdir("project")

# Clone and checkout the specified project repo from github
if args.code_dump_uri is None:
    subprocess.run(["git", "clone", "https://{}:x-oauth-basic@{}".format(args.oauth_token, args.git_url), "."])
    subprocess.run(["git", "checkout", args.commit_sha])
else:
    if args.platform == 'aws':
        subprocess.run(f'aws s3 cp --recursive {args.code_dump_uri} .', shell=True)

# Adding metadata to database
if args.db_hostname is None:
    raise RuntimeError('db_hostname was not passed in as an argument')
elif args.db_username_secret is None:
    raise RuntimeError('db_username_secret was not passed in as an argument')
elif args.db_password_secret is None:
    raise RuntimeError('db_password_secret was not passed in as an argument')
elif args.db_name is None:
    raise RuntimeError('db_name was not passed in as an argument')
else:
    secret = boto3.client('secretsmanager', region_name='us-east-1')
    username = secret.get_secret_value(SecretId=args.db_username_secret)['SecretString']
    password = secret.get_secret_value(SecretId=args.db_password_secret)['SecretString']

    conn = mysql.connector.connect(host=args.db_hostname, port=3306, user=username, passwd=password, database=args.db_name)
    cursor = conn.cursor()

    cursor.execute(f'''
        INSERT INTO job SET
        type_id={HYDRA_METADATA_JOB_TYPES['job']},
        name='{args.job_name}',
        job_uuid='{args.job_uuid}';
    ''')
    conn.commit()
    job_id = cursor.lastrowid

    cursor.execute(f'''
        INSERT INTO job_attribute SET k='Location', v='Batch', job_id={job_id};
    ''')
    cursor.execute(f'''
        INSERT INTO job_attribute SET k='Username', v='{args.username}', job_id={job_id};
    ''')
    cursor.execute(f'''
        INSERT INTO job_attribute SET k='IP Address', v='{args.ip_address}', job_id={job_id};
    ''')
    cursor.execute(f'''
        INSERT INTO job_attribute SET k='Image URI', v='{args.image_uri}', job_id={job_id};
    ''')
    cursor.execute(f'''
        INSERT INTO job_attribute SET k='Hydra Version', v='{args.hydra_version}', job_id={job_id};
    ''')
    conn.commit()

    cursor.close()

# Move data from tmp storage to project/data for local execution
if args.platform == 'local':
    if os.path.exists('/home/project/data'):
        shutil.rmtree('/home/project/data')
    shutil.copytree("/home/data", "/home/project/data")

subprocess.run(["conda", "env", "create", "-n", CONDA_ENV_NAME, "-f", "environment.yml"])
subprocess.run(["conda", "run", "-n", CONDA_ENV_NAME, "pip", "install", "hydra-ml"])

if args.options is not None:
    for arg in args.options.split():
        [key, val] = arg.split('=')
        os.putenv(key, val)

os.putenv('HYDRA_PLATFORM', args.platform)
os.putenv('HYDRA_GIT_URL', args.git_url or '')
os.putenv('HYDRA_COMMIT_SHA', args.commit_sha or '')
os.putenv('HYDRA_OAUTH_TOKEN', args.oauth_token)
os.putenv('HYDRA_MODEL_PATH', args.model_path)

subprocess.run(["conda", "run", "-n", CONDA_ENV_NAME, "python3", args.model_path])
