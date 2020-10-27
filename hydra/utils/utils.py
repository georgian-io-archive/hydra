def dict_to_string(packet):
    params = ""

    for key, value in packet.items():
        params += key + "=" + str(value) + " "

    return params.strip()
