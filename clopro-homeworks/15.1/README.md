# Домашнее задание к занятию «Организация сети»

### Подготовка к выполнению задания

1. Домашнее задание состоит из обязательной части, которую нужно выполнить на провайдере Yandex Cloud, и дополнительной части в AWS (выполняется по желанию). 
2. Все домашние задания в блоке 15 связаны друг с другом и в конце представляют пример законченной инфраструктуры.  
3. Все задания нужно выполнить с помощью Terraform. Результатом выполненного домашнего задания будет код в репозитории. 
4. Перед началом работы настройте доступ к облачным ресурсам из Terraform, используя материалы прошлых лекций и домашнее задание по теме «Облачные провайдеры и синтаксис Terraform». Заранее выберите регион (в случае AWS) и зону.

---
### Задание 1. Yandex Cloud 

**Что нужно сделать**

1. Создать пустую VPC. Выбрать зону.
2. Публичная подсеть.

 - Создать в VPC subnet с названием public, сетью 192.168.10.0/24.
 - Создать в этой подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использовать fd80mrhj8fl2oe87o4e1.
 - Создать в этой публичной подсети виртуалку с публичным IP, подключиться к ней и убедиться, что есть доступ к интернету.
3. Приватная подсеть.
 - Создать в VPC subnet с названием private, сетью 192.168.20.0/24.
 - Создать route table. Добавить статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс.
 - Создать в этой приватной подсети виртуалку с внутренним IP, подключиться к ней через виртуалку, созданную ранее, и убедиться, что есть доступ к интернету.

### Ответ

[Конфигурация Terraform](./terraform)

```
kmv@kmv-note:~$ yc vpc  network list --folder-id $YC_FOLDER_ID
+----------------------+--------+
|          ID          |  NAME  |
+----------------------+--------+
| enpkvshn0vrpcr2i78dv | my_vpc |
+----------------------+--------+

```
```
kmv@kmv-note:~$ yc vpc  subnet list --folder-id $YC_FOLDER_ID
+----------------------+---------+----------------------+----------------------+---------------+-------------------+
|          ID          |  NAME   |      NETWORK ID      |    ROUTE TABLE ID    |     ZONE      |       RANGE       |
+----------------------+---------+----------------------+----------------------+---------------+-------------------+
| e9b6rpmg86k3v5of90dn | private | enpkvshn0vrpcr2i78dv | enpr8oup4183hp6j2eqp | ru-central1-a | [192.168.20.0/24] |
| e9baf7j9sjfgd768dbrr | public  | enpkvshn0vrpcr2i78dv |                      | ru-central1-a | [192.168.10.0/24] |
+----------------------+---------+----------------------+----------------------+---------------+-------------------+

```
```
kmv@kmv-note:~$ yc vpc  route-table list --folder-id $YC_FOLDER_ID
+----------------------+------+-------------+----------------------+
|          ID          | NAME | DESCRIPTION |      NETWORK-ID      |
+----------------------+------+-------------+----------------------+
| enpr8oup4183hp6j2eqp |      |             | enpkvshn0vrpcr2i78dv |
+----------------------+------+-------------+----------------------+

kmv@kmv-note:~$ yc vpc  route-table get enpr8oup4183hp6j2eqp
id: enpr8oup4183hp6j2eqp
folder_id: b1gte6askt16s2a1m144
created_at: "2024-04-02T19:31:44Z"
network_id: enpkvshn0vrpcr2i78dv
static_routes:
  - destination_prefix: 0.0.0.0/0
    next_hop_address: 192.168.10.254
```
```
kmv@kmv-note:~$ yc compute instances list --folder-id $YC_FOLDER_ID
+----------------------+--------------+---------------+---------+---------------+----------------+
|          ID          |     NAME     |    ZONE ID    | STATUS  |  EXTERNAL IP  |  INTERNAL IP   |
+----------------------+--------------+---------------+---------+---------------+----------------+
| fhmbeco7a0ssebg52dt4 | public       | ru-central1-a | RUNNING | 51.250.83.162 | 192.168.10.29  |
| fhmcbp81ues5f88ovsqa | private      | ru-central1-a | RUNNING |               | 192.168.20.22  |
| fhmies26982u3miajpvt | nat-instance | ru-central1-a | RUNNING | 51.250.88.250 | 192.168.10.254 |
+----------------------+--------------+---------------+---------+---------------+----------------+

```

Проверка доступа в Интернет на public

```
kmv@kmv-note:~$ ssh ubuntu@51.250.83.162
Welcome to Ubuntu 22.04.4 LTS (GNU/Linux 5.15.0-101-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

  System information as of Tue Apr  2 07:56:10 PM UTC 2024

  System load:  0.0               Processes:             132
  Usage of /:   44.2% of 9.76GB   Users logged in:       0
  Memory usage: 12%               IPv4 address for eth0: 192.168.10.29
  Swap usage:   0%


Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


Last login: Tue Apr  2 19:34:39 2024 from 46.39.56.94
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@public:~$ ping ya.ru
PING ya.ru (5.255.255.242) 56(84) bytes of data.
64 bytes from ya.ru (5.255.255.242): icmp_seq=1 ttl=56 time=0.376 ms
64 bytes from ya.ru (5.255.255.242): icmp_seq=2 ttl=56 time=0.347 ms
64 bytes from ya.ru (5.255.255.242): icmp_seq=3 ttl=56 time=0.323 ms
^C
--- ya.ru ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2033ms
rtt min/avg/max/mdev = 0.323/0.348/0.376/0.021 ms
```

Проверка доступа в Интернет на private

```
ubuntu@public:~$ ssh 192.168.20.22
Welcome to Ubuntu 22.04.4 LTS (GNU/Linux 5.15.0-101-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

  System information as of Tue Apr  2 07:57:17 PM UTC 2024

  System load:  0.0               Processes:             130
  Usage of /:   45.1% of 9.76GB   Users logged in:       0
  Memory usage: 12%               IPv4 address for eth0: 192.168.20.22
  Swap usage:   0%


Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


Last login: Tue Apr  2 19:40:33 2024 from 192.168.10.29
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@private:~$ ping ya.ru
PING ya.ru (5.255.255.242) 56(84) bytes of data.
64 bytes from ya.ru (5.255.255.242): icmp_seq=1 ttl=52 time=1.60 ms
64 bytes from ya.ru (5.255.255.242): icmp_seq=2 ttl=52 time=0.727 ms
64 bytes from ya.ru (5.255.255.242): icmp_seq=3 ttl=52 time=0.743 ms
^C
--- ya.ru ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 0.727/1.024/1.603/0.409 ms
```
