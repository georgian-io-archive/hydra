import json
from collections import OrderedDict

def json_to_string(packet):
    od = json.loads(packet, object_pairs_hook=OrderedDict)

    params = ""
    for key, value in od.items():
        params += key + "=" + str(value) + " "

    return params.strip()
