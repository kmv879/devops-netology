Домашнее задание 3.7

1. В Windows применяется команда ipconfig  

PS C:\Users\mkozh> ipconfig -all  
Адаптер беспроводной локальной сети Беспроводная сеть 2:  
  
   DNS-суффикс подключения . . . . . :  
   Описание. . . . . . . . . . . . . : Intel(R) Wi-Fi 6E AX210 160MHz  
   Физический адрес. . . . . . . . . : 2C-0D-A7-21-27-08  
   DHCP включен. . . . . . . . . . . : Да  
   Автонастройка включена. . . . . . : Да  
   Локальный IPv6-адрес канала . . . : fe80::15cd:1274:ec40:79ca%17(Основной)  
   IPv4-адрес. . . . . . . . . . . . : 192.168.1.49(Основной)  
   Маска подсети . . . . . . . . . . : 255.255.255.0  
   Аренда получена. . . . . . . . . . : 5 июля 2022 г. 12:55:51  
   Срок аренды истекает. . . . . . . . . . : 5 июля 2022 г. 19:58:58  
   Основной шлюз. . . . . . . . . : 192.168.1.1  
   DHCP-сервер. . . . . . . . . . . : 192.168.1.1  
   IAID DHCPv6 . . . . . . . . . . . : 304876967  
   DUID клиента DHCPv6 . . . . . . . : 00-01-00-01-2A-06-8F-3B-7C-C2-C6-29-7E-4B  
   DNS-серверы. . . . . . . . . . . : 192.168.1.1  
   NetBios через TCP/IP. . . . . . . . : Включен  
 
 В Linux применяется команда ip  
 
vagrant@vagrant:~$ vagrant@vagrant:~$ ip addr  
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000  
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00  
    inet 127.0.0.1/8 scope host lo  
       valid_lft forever preferred_lft forever  
    inet6 ::1/128 scope host  
       valid_lft forever preferred_lft forever  
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000  
    link/ether 08:00:27:b1:28:5d brd ff:ff:ff:ff:ff:ff  
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0  
       valid_lft 86308sec preferred_lft 86308sec  
    inet6 fe80::a00:27ff:feb1:285d/64 scope link  
       valid_lft forever preferred_lft forever  
	   
	   
	   
	   
	   
2. Используется протокол канального уровня LLDP. В Linux применяется пакет lldpd.  
vagrant@vagrant:~$ sudo apt install lldpd  

vagrant@vagrant:~$ lldpctl  
 
LLDP neighbors:  
  
Interface:    eth0, via: LLDP, RID: 2, Time: 0 day, 00:01:45  
  Chassis:  
    ChassisID:    mac 1c:1b:0d:e6:52:9f  
  Port:  
    PortID:       mac 1c:1b:0d:e6:52:9f  
    TTL:          3601  
    PMD autoneg:  supported: yes, enabled: yes  
      Adv:          1000Base-T, HD: no, FD: yes  
      MAU oper type: unknown  
  LLDP-MED:  
    Device Type:  Generic Endpoint (Class I)  
    Capability:   Capabilities, yes  
  




3. Для разделения коммутатора на виртуальные сети используются vlan. В Linux применяется пакет vlan.  
Пример конфига.   
sudo nano /etc/netplan/01-netcfg.yaml  

network:  
  version: 2  
  ethernets:  
    eth0:  
      dhcp4: true  
  vlans:  
        eth0.100:  
            id: 100  
            link: eth0  
            addresses: [192.168.2.2/24]  
			
vagrant@vagrant:/etc/netplan$ ip a  
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000  
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00  
    inet 127.0.0.1/8 scope host lo  
       valid_lft forever preferred_lft forever  
    inet6 ::1/128 scope host  
       valid_lft forever preferred_lft forever  
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000  
    link/ether 08:00:27:b1:28:5d brd ff:ff:ff:ff:ff:ff  
    inet 192.168.1.70/24 brd 192.168.1.255 scope global dynamic eth0  
       valid_lft 25195sec preferred_lft 25195sec  
    inet6 fe80::a00:27ff:feb1:285d/64 scope link  
       valid_lft forever preferred_lft forever  
3: eth0.100@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000  
    link/ether 08:00:27:b1:28:5d brd ff:ff:ff:ff:ff:ff  
    inet 192.168.2.2/24 brd 192.168.2.255 scope global eth0.100  
       valid_lft forever preferred_lft forever  
    inet6 fe80::a00:27ff:feb1:285d/64 scope link  
       valid_lft forever preferred_lft forever  




4. В Linux есть статическая агрегация интерфейсов и динамическая по протоколу LACP. Для балансировки нагрузки испульзуются режимы:  
mode=0 (balance-rr)  
mode=2 (balance-xor)  
mode=5 (balance-tlb)  
mode=6 (balance-alb)  

Пример конфига  

network:  
  version: 2  
  ethernets:  
    eth0:  
       dhcp4: no  
    eth1:  
       dhcp4: no  
  bonds:  
    bond0:  
       dhcp4: true  
       interfaces:  
          - eth0  
          - eth1  
       parameters:  
          mode: balance-rr  

vagrant@vagrant:/etc/netplan$ ip a  

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000  
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00  
    inet 127.0.0.1/8 scope host lo  
       valid_lft forever preferred_lft forever  
    inet6 ::1/128 scope host  
       valid_lft forever preferred_lft forever  
2: eth0: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc fq_codel master bond0 state UP group default qlen 1000  
    link/ether de:25:97:ee:c8:82 brd ff:ff:ff:ff:ff:ff  
3: eth1: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc fq_codel master bond0 state UP group default qlen 1000  
    link/ether de:25:97:ee:c8:82 brd ff:ff:ff:ff:ff:ff  
4: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000  
    link/ether de:25:97:ee:c8:82 brd ff:ff:ff:ff:ff:ff  
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic bond0  
       valid_lft 86298sec preferred_lft 86298sec  
    inet6 fe80::dc25:97ff:feee:c882/64 scope link  
       valid_lft forever preferred_lft forever  




5. В сети с маской /29 8 IP адресов. Из сети с маской /24 можно получить 32 подсети с маской /29.  
10.10.10.0/29  
10.10.10.8/29  
10.10.10.16/29  
10.10.10.24/29  




6. Допустимо использовать IP адреса из сети 100.64.0.0/10. Подсеть на 40-50 хостов будет 100.64.0.0/26  




7. Просмотр таблицы arp в Windows командой arp -a. Удаление определенной записи arp -d <IP адрес>. Удаление всех записей arp -d *.
В Linux просмотр таблицы производится командой ip neigh. Удаление определенной записи ip neigh del <IP адрес> dev <сетевой интерфейс>. Удаление всех записей ip neigh flush.



