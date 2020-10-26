import json
from collections import OrderedDict

def json_to_string(packet):
    params = ""

    # Accepts [{'project_name': 'project'}, {'bucket_name': 'bucket'}, {'blob_path': 'path'}]
    if isinstance(packet, list):
        for d in packet:
            for key, val in d.items():
                params += key + "=" + str(val) + " "

    else:
        od = json.loads(packet, object_pairs_hook=OrderedDict)
        for key, value in od.items():
            params += key + "=" + str(value) + " "

    return params.strip()
