import sqlalchemy
import boto3


def initialize_db(event, context):
    region = event['aws_region']

    s3 = boto3.client('s3', region_name=region)
    secret = boto3.client('secretsmanager', region_name=region)

    obj = s3.get_object(Bucket=event['table_setup_script_bucket_name'], Key=event['table_setup_script_bucket_key'])
    command_string = obj['Body'].read().decode('utf-8')

    commands = command_string.split(';')

    database_hostname = event['database_hostname']
    username = secret.get_secret_value(SecretId=event['database_username_secret'])['SecretString']
    password = secret.get_secret_value(SecretId=event['database_password_secret'])['SecretString']
    db_name = event['database_default_name']

    db_connection = sqlalchemy.create_engine(f'mysql+pymysql://{username}:'
                                             f'{password}@'
                                             f'{database_hostname}:'
                                             f'3306/'
                                             f'{db_name}').connect()

    for command in commands:
        if command or command.strip():
            db_connection.execute(f'{command};')