import re
import json
import subprocess

def json_to_string(packet):
    dic = json.loads(packet)

    params = ""
    for key, value in dic.items():
        params += key + "=" + str(value) + " "

    return params.strip()


def get_repo_url():
    git_url = subprocess.check_output("git config --get remote.origin.url", shell=True).decode("utf-8").strip()
    git_url = re.compile(r"https?://(www\.)?").sub("", git_url).strip().strip('/')
    return git_url


def get_commit_sha():
    commit_sha = subprocess.check_output("git log --pretty=tformat:'%h' -n1 .", shell=True).decode("utf-8").strip()
    return commit_sha
