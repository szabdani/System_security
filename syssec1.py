import os.path as path
import json
import socket

class Module:
    def __init__(self, incoming=False, verbose=False, options=None):
        # extract the file name from __file__. __file__ is proxymodules/name.py
        self.name = path.splitext(path.basename(__file__))[0]
        self.description = 'Simply print the received data as text'
        self.incoming = incoming  # incoming means module is on -im chain
        self.find = None  # if find is not None, this text will be highlighted

    def execute(self, data):
        print(f"Incoming data: {data}")

        # Using Reflection Attack as mentioned in the lecture
        # Impersonating Bob and sending Alice her own replies

        data_json = json.loads(data)

        # Here we are making Alice encrypt her own nonce together with current session key, with only difference,
        # that the message comes from Bo
        # Reflect packet and change content to identify Bob with Alice's nonce
        if data_json["id"] == 1:
            original_sender, original_receiver = data_json["sender"], data_json["receiver"]
            data_json["sender"], data_json["receiver"] = original_receiver, original_sender

            nonce = str(data_json["content"])

            # How to get last part of string
            # https://stackoverflow.com/questions/16118379/get-characters-of-a-string-from-right

            data_json["content"] = "Bob," + nonce[-10:]
            data = json.dumps(data_json) + '\n'

        # Reflect packet - After this message Alice confirm's her own nonce, which she thinks Bob encrypted
        if data_json["id"] == 2:
            original_sender, original_receiver = data_json["sender"], data_json["receiver"]
            data_json["sender"], data_json["receiver"] = original_receiver, original_sender
            data = json.dumps(data_json) + '\n'
            
        # Reflect packet - Alice again checks that nonce is correct, this time as if she was Bob in the original relation
        if data_json["id"] == 3:
            original_sender, original_receiver = data_json["sender"], data_json["receiver"]
            data_json["sender"], data_json["receiver"] = original_receiver, original_sender
            data = json.dumps(data_json) + '\n'

        # Reflect packet - completing and adding Bob's made up nonce
        if data_json["id"] == 4:
            original_sender, original_receiver = data_json["sender"], data_json["receiver"]
            data_json["sender"], data_json["receiver"] = original_receiver, original_sender
            data_json["content"] = "1234567890" # Making our own nonce which does not matter, and establishing connection with Alice
            data = json.dumps(data_json) + '\n'

            # After reflecting last packet and sending Alice her own non encrypted nonce, 
            # getting flag: n3v3r_tru5t_b0b


        print(f"Outgoing data: {data}")
        return data





if __name__ == '__main__':
    print('This module is not supposed to be executed alone!')
