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

        data_json = json.loads(data)

        # Here we can totally put Trent out of action and just reply to Bob with his own messages
        # Bob does not check if his nonce from Alice comes back encrypted or not, when not encrypted returned to Bob,
        # he himself builds message which he expects from Trent

        # Reflect packet with id 2 back to Bob, he thinks content is cyphered from Alice, while it is his plain nonce
        if data_json["id"] == 2:
            original_sender, original_receiver = data_json["sender"], data_json["receiver"]
            data_json["sender"], data_json["receiver"] = original_receiver, original_sender
            data_json["id"] = 3
            data = json.dumps(data_json) + '\n'

        # Again, reflect packet back to Bob and make him think Trent deciphered Bob's nonce encrypted by Eve
        elif data_json["id"] == 4:
            data_json["sender"] = "Trent"
            data_json["receiver"] = "Bob"
            data_json["id"] = 5
            data = json.dumps(data_json) + '\n'

        print(f"Outgoing data: {data}")
        return data

        # Now Bob thinks we are authenticated Alice

        # After completing this challenge the flag is: 4uth3nt1c4t10n_1s_1mp0rt4nt

if __name__ == '__main__':
    print('This module is not supposed to be executed alone!')
