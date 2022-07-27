Домашнее задание 3.9

1. Скриншот установленного плагина Bitwarden с сохраненным паролем находится в файле bitwarden.png

2. Скриншот настроек OTP находится в файле bitwarden-otp.jpg. Использовалось приложение Яндекс.ключ

3. Создание самоподписанного сертификата в nginx

```
root@vagrant:/home/vagrant# mkdir /etc/nginx/ssl
root@vagrant:/home/vagrant# chown root:root /etc/nginx/ssl
root@vagrant:/home/vagrant# chmod 700 /etc/nginx/ssl
root@vagrant:/home/vagrant# cd /etc/nginx/ssl
root@vagrant:/etc/nginx/ssl# openssl req -new -x509 -days 9999 -nodes -newkey rsa:2048 -out cert.pem -keyout cert.key
Generating a RSA private key
.....+++++
..............+++++
writing new private key to 'cert.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:RU
State or Province Name (full name) [Some-State]:
Locality Name (eg, city) []:Ufa
Organization Name (eg, company) [Internet Widgits Pty Ltd]:SomeCompany
Organizational Unit Name (eg, section) []:UnitName
Common Name (e.g. server FQDN or YOUR name) []:example.com
Email Address []:mail@example.com
```

Внесение изменений в файл `/etc/nginx/nginx.conf`
```
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping SSLv3, ref: POO>
        ssl_prefer_server_ciphers on;
        ssl_certificate /etc/nginx/ssl/cert.pem;
        ssl_certificate_key /etc/nginx/ssl/cert.key;
```
Внесение изменений в файл `/etc/nginx/sites-enabled/default`
```
        listen 443 ssl default_server;
        listen [::]:443 ssl default_server;
```

Скриншот работы сайта по https находится в файле nginx.png

5. Проверка сайта на TLS уязвимости
```
vagrant@vagrant:~/git/testssl.sh$ ./testssl.sh -U --sneaky https://netology.ru

###########################################################
    testssl.sh       3.1dev from https://testssl.sh/dev/
    (88e80d2 2022-07-02 22:13:06)

      This program is free software. Distribution and
             modification under GPLv2 permitted.
      USAGE w/o ANY WARRANTY. USE IT AT YOUR OWN RISK!

       Please file bugs @ https://testssl.sh/bugs/

###########################################################

 Using "OpenSSL 1.0.2-chacha (1.0.2k-dev)" [~183 ciphers]
 on vagrant:./bin/openssl.Linux.x86_64
 (built: "Jan 18 17:12:17 2019", platform: "linux-x86_64")


 Start 2022-07-27 15:42:38        -->> 188.114.98.160:443 (netology.ru) <<--

 Further IP addresses:   2a06:98c1:3123:a000::
 rDNS (188.114.98.160):  --
 Service detected:       HTTP


 Testing vulnerabilities

 Heartbleed (CVE-2014-0160)                not vulnerable (OK), no heartbeat extension
 CCS (CVE-2014-0224)                       not vulnerable (OK)
 Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK)
 ROBOT                                     not vulnerable (OK)
 Secure Renegotiation (RFC 5746)           supported (OK)
 Secure Client-Initiated Renegotiation     not vulnerable (OK)
 CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
 BREACH (CVE-2013-3587)                    potentially NOT ok, "gzip" HTTP compression detected. - only supplied "/" tested
                                           Can be ignored for static pages or if no secrets in the page
 POODLE, SSL (CVE-2014-3566)               not vulnerable (OK)
 TLS_FALLBACK_SCSV (RFC 7507)              Downgrade attack prevention supported (OK)
 SWEET32 (CVE-2016-2183, CVE-2016-6329)    VULNERABLE, uses 64 bit block ciphers
 FREAK (CVE-2015-0204)                     not vulnerable (OK)
 DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)
                                           make sure you don't use this certificate elsewhere with SSLv2 enabled services, see
                                           https://search.censys.io/search?resource=hosts&virtual_hosts=INCLUDE&q=A3C7D9A8D3805171D99EA61F5C80B8ADF49B93BA21EBB492D78512BA254E90A5
 LOGJAM (CVE-2015-4000), experimental      not vulnerable (OK): no DH EXPORT ciphers, no DH key detected with <= TLS 1.2 BEAST (CVE-2011-3389)                     TLS1: ECDHE-RSA-AES128-SHA AES128-SHA ECDHE-RSA-AES256-SHA AES256-SHA
                                                 DES-CBC3-SHA
                                           VULNERABLE -- but also supports higher protocols  TLSv1.1 TLSv1.2 (likely mitigated)
 LUCKY13 (CVE-2013-0169), experimental     potentially VULNERABLE, uses cipher block chaining (CBC) ciphers with TLS. Check patches
 Winshock (CVE-2014-6321), experimental    not vulnerable (OK)
 RC4 (CVE-2013-2566, CVE-2015-2808)        no RC4 ciphers detected (OK)


 Done 2022-07-27 15:43:19 [  44s] -->> 188.114.98.160:443 (netology.ru) <<--
 ```
 
 6. Генерирование SSH ключа
  ```
 vagrant@vagrant:~/.ssh$ ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/home/vagrant/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/vagrant/.ssh/id_rsa
Your public key has been saved in /home/vagrant/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:TNumvX0lbnCSIZ8vw0VOUXIAzFG3/bCT95/NRDNM8Ug vagrant@vagrant
The key's randomart image is:
+---[RSA 3072]----+
|           oo+E++|
|            o..==|
|        .     o+o|
|       o o. . =+.|
|        S oo B+++|
|         +  * =+=|
|        . .. B oo|
|           o+ =o+|
|          . .= .+|
+----[SHA256]-----+
```

Копирование ключа на сервер
```
vagrant@vagrant:~/.ssh$ ssh-copy-id vagrant@192.168.1.70
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/vagrant/.ssh/id_rsa.pub"
The authenticity of host '192.168.1.70 (192.168.1.70)' can't be established.
ECDSA key fingerprint is SHA256:RztZ38lZsUpiN3mQrXHa6qtsUgsttBXWJibL2nAiwdQ.
Are you sure you want to continue connecting (yes/no/[fingerprint])? y
Please type 'yes', 'no' or the fingerprint: yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
vagrant@192.168.1.70's password:

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'vagrant@192.168.1.70'"
and check to make sure that only the key(s) you wanted were added.
```

Подключение к серверу
```
vagrant@vagrant:~/.ssh$ ssh 'vagrant@192.168.1.70'
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Wed 27 Jul 2022 03:53:16 PM UTC

  System load:  0.0                Processes:             137
  Usage of /:   12.4% of 30.88GB   Users logged in:       1
  Memory usage: 23%                IPv4 address for eth0: 192.168.1.70
  Swap usage:   0%


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Wed Jul 27 08:13:05 2022 from 192.168.1.49
```

7. Переименование ключей
```
vagrant@vagrant:~/.ssh$ mv id_rsa my_rsa
vagrant@vagrant:~/.ssh$ mv id_rsa.pub my_rsa.pub
```
Создание файла `~/.ssh/config`
```
Host my_ubuntu
User vagrant
HostName 192.168.1.70
Port 22
IdentityFile ~/.ssh/my_rsa
```
Подключение по имени
```
vagrant@vagrant:~/.ssh$ ssh my_ubuntu
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Wed 27 Jul 2022 04:03:14 PM UTC

  System load:  0.0                Processes:             135
  Usage of /:   12.4% of 30.88GB   Users logged in:       1
  Memory usage: 23%                IPv4 address for eth0: 192.168.1.70
  Swap usage:   0%


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Wed Jul 27 16:00:47 2022 from 192.168.1.49
```
7. Захват 100 пакетов трафика

```
sudo tcpdump -w 0001.pcap -i eth0 -c 100
```

Скриншот файла 0001.cap, открытого в Wireshark, находится в файле wireshark.png
