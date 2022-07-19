Домашнее задание 3.8

1. 
```
vagrant@vagrant:~$ dig @resolver4.opendns.com myip.opendns.com +short
178.129.132.20

route-views>sh ip route 178.129.132.20 255.255.255.255
Routing entry for 178.129.0.0/16
  Known via "bgp 6447", distance 20, metric 0
  Tag 2497, type external
  Last update from 202.232.0.2 7w0d ago
  Routing Descriptor Blocks:
  * 202.232.0.2, from 202.232.0.2, 7w0d ago
      Route metric is 0, traffic share count is 1
      AS Hops 3
      Route tag 2497
      MPLS label: none
```
Команда `sh bgp 178.129.132.20 255.255.255.255` не работает.
```
route-views>sh bgp 178.129.132.20 255.255.255.255
% Network not in table	  
```
Отображает только для сети 178.129.0.0/16
```
route-views>sh bgp 178.129.132.20
BGP routing table entry for 178.129.0.0/16, version 281622940
Paths: (24 available, best #22, table default)
  Not advertised to any peer
  Refresh Epoch 1
  20912 3257 1273 12389 28812
    212.66.96.126 from 212.66.96.126 (212.66.96.126)
      Origin IGP, localpref 100, valid, external
      Community: 3257:8070 3257:30352 3257:50001 3257:53900 3257:53902 20912:65004
      path 7FE0DB205788 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3333 1103 12389 28812
    193.0.0.56 from 193.0.0.56 (193.0.0.56)
      Origin IGP, localpref 100, valid, external
      path 7FE11C9B0300 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  4901 6079 1299 12389 28812
    162.250.137.254 from 162.250.137.254 (162.250.137.254)
      Origin IGP, localpref 100, valid, external
      Community: 65000:10100 65000:10300 65000:10400
      path 7FE16AAA57F0 RPKI State not found
      rx pathid: 0, tx pathid: 0
```

2. Создание dummy интерфейса
```
/etc/systemd/network/dummy0.netdev
```
```
[NetDev]
   Name=dummy0
   Kind=dummy
```
```
/etc/systemd/network/dummy0.network
```
```
[Match]
   Name=dummy0

[Network]
   Address=10.1.10.2/32
```
```
vagrant@vagrant:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:b1:28:5d brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
       valid_lft 86045sec preferred_lft 86045sec
    inet6 fe80::a00:27ff:feb1:285d/64 scope link
       valid_lft forever preferred_lft forever
3: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether 1a:70:2e:84:6a:3c brd ff:ff:ff:ff:ff:ff
    inet 10.1.10.2/32 scope global dummy0
       valid_lft forever preferred_lft forever
    inet6 fe80::1870:2eff:fe84:6a3c/64 scope link
       valid_lft forever preferred_lft forever
```

Настройка статических маршрутов
```
/etc/netplan/01-netcfg.yaml
```
```
network:
  version: 2
  ethernets:
    eth0:
       dhcp4: true
       routes:
          - to: 10.10.1.0/24
            via: 192.168.12.1
            on-link: true
          - to: 10.20.1.0/24
            via: 192.168.12.1
            on-link: true
```
```
vagrant@vagrant:~$ ip r
default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100
10.10.1.0/24 via 192.168.12.1 dev eth0 proto static onlink
10.20.1.0/24 via 192.168.12.1 dev eth0 proto static onlink
```

 3. Просмотр открытых TCP портов
 ```
 vagrant@vagrant:~$ sudo ss -tlpn
State    Recv-Q   Send-Q      Local Address:Port       Peer Address:Port   Process
LISTEN   0        4096        127.0.0.53%lo:53              0.0.0.0:*       users:(("systemd-resolve",pid=628,fd=13))
LISTEN   0        128               0.0.0.0:22              0.0.0.0:*       users:(("sshd",pid=700,fd=3))
LISTEN   0        128                  [::]:22                 [::]:*       users:(("sshd",pid=700,fd=4))
```
Порт 53 используется службой DNS, порт 22 SSH

4. Просмотр используемых сокетов UDP
```
vagrant@vagrant:~$ sudo ss -ulpn
State    Recv-Q   Send-Q      Local Address:Port       Peer Address:Port   Process
UNCONN   0        0           127.0.0.53%lo:53              0.0.0.0:*       users:(("systemd-resolve",pid=628,fd=12))
UNCONN   0        0          10.0.2.15%eth0:68              0.0.0.0:*       users:(("systemd-network",pid=1155,fd=22))
```
 53 - DNS, 68 - DHCP
 
 
 5. Схема сети в приложенном файле network.jpg