from itertools import product


def dict_product(dict):
    """ Uppack {"name": "cool-exp", "lr": [0.01, 0.001]} to list of cartesian products
    [{"name": "cool-exp", "lr": 0.01}, {"name": "cool-exp", "lr": 0.001}]
    """
    products = []

    list_dict = {}
    for key, values in dictionary.items():
        if not isinstance(values, list):
            list_dict[key] = [values]
        else:
            list_dict[key] = values

    for values in product(*list_dict.values()):
        products.append(dict(zip(list_dict.keys(), values)))

    return products


def dict_to_string(packet):
    """ Convert dictionary {"epoch": 10, "lr": 0.01} to string "epoch=10 lr=0.01"
    """
    params = ""

    for key, value in packet.items():
        params += key + "=" + str(value) + " "

    return params.strip()
