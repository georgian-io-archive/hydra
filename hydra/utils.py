import json

def json_to_string(packet):
    dic = json.loads(packet)

    params = ""
    for key, value in dic.items():
        params += key + "=" + str(value) + " "

    return params.strip()
