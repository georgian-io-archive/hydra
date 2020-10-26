import json
from collections import OrderedDict

def json_to_string(packet):
    params = ""

    od = json.loads(packet, object_pairs_hook=OrderedDict)
    for key, value in od.items():
        params += key + "=" + str(value) + " "

    return params.strip()
