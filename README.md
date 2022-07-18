Домашнее задание 3.5

1. Разрежённый файл  — файл, в котором последовательности нулевых байтов заменены на информацию об этих последовательностях. Разрежённые файлы используются для хранения контейнеров,например:
образов дисков виртуальных машин, резервных копий дисков и/или разделов, созданных спец. ПО.

2. Файлы, являющиеся жесткой ссылкой на один объект, не могут иметь разные права доступа, так как имеют одну и ту же inode, в которой хранятся права.

3. Создано 2 диска по 2.5ГБ
```
vagrant@vagrant:~$ lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop /snap/core18/2128
loop1                       7:1    0 55.5M  1 loop /snap/core18/2409
loop3                       7:3    0 67.8M  1 loop /snap/lxd/22753
loop4                       7:4    0 61.9M  1 loop /snap/core20/1518
loop5                       7:5    0 70.3M  1 loop /snap/lxd/21029
loop6                       7:6    0   47M  1 loop /snap/snapd/16292
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm  /
sdb                         8:16   0  2.5G  0 disk
sdc                         8:32   0  2.5G  0 disk
```

4.  Создание разделов на первом диске
```
vagrant@vagrant:~$ sudo fdisk /dev/sdb

Welcome to fdisk (util-linux 2.34).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): n
Partition number (1-128, default 1): 1
First sector (2048-5242846, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242846, default 5242846): +2G

Created a new partition 1 of type 'Linux filesystem' and of size 2 GiB.

Command (m for help): n
Partition number (2-128, default 2):
First sector (4196352-5242846, default 4196352):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242846, default 5242846):

Created a new partition 2 of type 'Linux filesystem' and of size 511 MiB.

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.


vagrant@vagrant:~$ lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop /snap/core18/2128
loop1                       7:1    0 55.5M  1 loop /snap/core18/2409
loop3                       7:3    0 67.8M  1 loop /snap/lxd/22753
loop4                       7:4    0 61.9M  1 loop /snap/core20/1518
loop5                       7:5    0 70.3M  1 loop /snap/lxd/21029
loop6                       7:6    0   47M  1 loop /snap/snapd/16292
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm  /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
└─sdb2                      8:18   0  511M  0 part
sdc                         8:32   0  2.5G  0 disk
```

5. Перенос таблицы разделов на второй диск
```
vagrant@vagrant:~$ sudo bash -c "sfdisk -d /dev/sdb | sfdisk /dev/sdc"
Checking that no-one is using this disk right now ... OK

Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new GPT disklabel (GUID: FFF5492F-C879-574C-8E3E-853B02BA4C4B).
/dev/sdc1: Created a new partition 1 of type 'Linux filesystem' and of size 2 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux filesystem' and of size 511 MiB.
/dev/sdc3: Done.

New situation:
Disklabel type: gpt
Disk identifier: FFF5492F-C879-574C-8E3E-853B02BA4C4B

Device       Start     End Sectors  Size Type
/dev/sdc1     2048 4196351 4194304    2G Linux filesystem
/dev/sdc2  4196352 5242846 1046495  511M Linux filesystem

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

vagrant@vagrant:~$ lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop /snap/core18/2128
loop1                       7:1    0 55.5M  1 loop /snap/core18/2409
loop3                       7:3    0 67.8M  1 loop /snap/lxd/22753
loop4                       7:4    0 61.9M  1 loop /snap/core20/1518
loop5                       7:5    0 70.3M  1 loop /snap/lxd/21029
loop6                       7:6    0   47M  1 loop /snap/snapd/16292
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm  /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
└─sdb2                      8:18   0  511M  0 part
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
└─sdc2                      8:34   0  511M  0 part
```

6. Создание RAID1
```
vagrant@vagrant:~$ sudo mdadm --create /dev/md1 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
vagrant@vagrant:~$ lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop  /snap/core18/2128
loop1                       7:1    0 55.5M  1 loop  /snap/core18/2409
loop3                       7:3    0 67.8M  1 loop  /snap/lxd/22753
loop4                       7:4    0 61.9M  1 loop  /snap/core20/1518
loop5                       7:5    0 70.3M  1 loop  /snap/lxd/21029
loop6                       7:6    0   47M  1 loop  /snap/snapd/16292
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part  /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
└─sdb2                      8:18   0  511M  0 part
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
└─sdc2                      8:34   0  511M  0 part
```

7. Создание RAID0
```
vagrant@vagrant:~$ sudo mdadm --create /dev/md2 --level=0 --raid-devices=2 /dev/sdb2 /dev/sdc2
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md2 started.
vagrant@vagrant:~$ lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop  /snap/core18/2128
loop1                       7:1    0 55.5M  1 loop  /snap/core18/2409
loop3                       7:3    0 67.8M  1 loop  /snap/lxd/22753
loop4                       7:4    0 61.9M  1 loop  /snap/core20/1518
loop5                       7:5    0 70.3M  1 loop  /snap/lxd/21029
loop6                       7:6    0   47M  1 loop  /snap/snapd/16292
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part  /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
└─sdb2                      8:18   0  511M  0 part
  └─md2                     9:2    0 1017M  0 raid0
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
└─sdc2                      8:34   0  511M  0 part
  └─md2                     9:2    0 1017M  0 raid0
```

8. Создание PV
```
vagrant@vagrant:~$ sudo pvcreate /dev/md1
  Physical volume "/dev/md1" successfully created.
vagrant@vagrant:~$ sudo pvcreate /dev/md2
  Physical volume "/dev/md2" successfully created.
vagrant@vagrant:~$ sudo pvs
  PV         VG        Fmt  Attr PSize    PFree
  /dev/md1             lvm2 ---    <2.00g   <2.00g
  /dev/md2             lvm2 ---  1017.00m 1017.00m
  /dev/sda3  ubuntu-vg lvm2 a--   <63.00g  <31.50g
```

9. Создание VG
```
vagrant@vagrant:~$ sudo vgcreate homework_VG /dev/md1 /dev/md2
  Volume group "homework_VG" successfully created
vagrant@vagrant:~$ sudo vgs
  VG          #PV #LV #SN Attr   VSize   VFree
  homework_VG   2   0   0 wz--n-  <2.99g  <2.99g
  ubuntu-vg     1   1   0 wz--n- <63.00g <31.50g
```

10. Создание LV
```
vagrant@vagrant:~$ sudo lvcreate -L 100M -n homework_LV /dev/homework_VG /dev/md2
  Logical volume "homework_LV" created.
vagrant@vagrant:~$ sudo lvs -a -o +devices
  LV          VG          Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert Devices
  homework_LV homework_VG -wi-a----- 100.00m                                                     /dev/md2(0)
  ubuntu-lv   ubuntu-vg   -wi-ao----  31.50g                                                     /dev/sda3(0)
```

11. Создание файловой системы
```
vagrant@vagrant:/dev/homework_VG$ sudo mkfs.ext4 /dev/homework_VG/homework_LV
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done
```

12. Монтирование раздела
```
vagrant@vagrant:/dev/homework_VG$ mkdir /tmp/new
vagrant@vagrant:/dev/homework_VG$ sudo mount /dev/homework_VG/homework_LV /tmp/new/
vagrant@vagrant:/dev/homework_VG$ df -h | grep 'homework'
/dev/mapper/homework_VG-homework_LV   93M   72K   86M   1% /tmp/new
```

13. Тестовый файл
```
vagrant@vagrant:/dev/homework_VG$ sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2022-07-18 09:47:56--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 23735569 (23M) [application/octet-stream]
Saving to: ‘/tmp/new/test.gz’

/tmp/new/test.gz              100%[=================================================>]  22.64M  1.98MB/s    in 12s

2022-07-18 09:48:08 (1.84 MB/s) - ‘/tmp/new/test.gz’ saved [23735569/23735569]

vagrant@vagrant:/dev/homework_VG$ ls /tmp/new
lost+found  test.gz
```

14. Вывод lsblk
```
vagrant@vagrant:/dev/homework_VG$ lsblk
NAME                          MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                           7:0    0 55.4M  1 loop  /snap/core18/2128
loop1                           7:1    0 55.5M  1 loop  /snap/core18/2409
loop3                           7:3    0 67.8M  1 loop  /snap/lxd/22753
loop4                           7:4    0 61.9M  1 loop  /snap/core20/1518
loop5                           7:5    0 70.3M  1 loop  /snap/lxd/21029
loop6                           7:6    0   47M  1 loop  /snap/snapd/16292
sda                             8:0    0   64G  0 disk
├─sda1                          8:1    0    1M  0 part
├─sda2                          8:2    0    1G  0 part  /boot
└─sda3                          8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv     253:0    0 31.5G  0 lvm   /
sdb                             8:16   0  2.5G  0 disk
├─sdb1                          8:17   0    2G  0 part
│ └─md1                         9:1    0    2G  0 raid1
└─sdb2                          8:18   0  511M  0 part
  └─md2                         9:2    0 1017M  0 raid0
    └─homework_VG-homework_LV 253:1    0  100M  0 lvm   /tmp/new
sdc                             8:32   0  2.5G  0 disk
├─sdc1                          8:33   0    2G  0 part
│ └─md1                         9:1    0    2G  0 raid1
└─sdc2                          8:34   0  511M  0 part
  └─md2                         9:2    0 1017M  0 raid0
    └─homework_VG-homework_LV 253:1    0  100M  0 lvm   /tmp/new
```

15. Проверка целостности архива
```
vagrant@vagrant:/dev/homework_VG$ gzip -t /tmp/new/test.gz
vagrant@vagrant:/dev/homework_VG$ echo $?
0
```

16. Перенос LV на другой PV
```
vagrant@vagrant:/dev/homework_VG$ sudo pvmove -n homework_LV /dev/md2 /dev/md1
  /dev/md2: Moved: 32.00%
  /dev/md2: Moved: 100.00%
vagrant@vagrant:/dev/homework_VG$ sudo lvs -a -o +devices
  LV          VG          Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert Devices
  homework_LV homework_VG -wi-ao---- 100.00m                                                     /dev/md1(0)
  ubuntu-lv   ubuntu-vg   -wi-ao----  31.50g                                                     /dev/sda3(0)
vagrant@vagrant:/dev/homework_VG$ lsblk
NAME                          MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                           7:0    0 55.4M  1 loop  /snap/core18/2128
loop1                           7:1    0 55.5M  1 loop  /snap/core18/2409
loop3                           7:3    0 67.8M  1 loop  /snap/lxd/22753
loop4                           7:4    0 61.9M  1 loop  /snap/core20/1518
loop5                           7:5    0 70.3M  1 loop  /snap/lxd/21029
loop6                           7:6    0   47M  1 loop  /snap/snapd/16292
sda                             8:0    0   64G  0 disk
├─sda1                          8:1    0    1M  0 part
├─sda2                          8:2    0    1G  0 part  /boot
└─sda3                          8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv     253:0    0 31.5G  0 lvm   /
sdb                             8:16   0  2.5G  0 disk
├─sdb1                          8:17   0    2G  0 part
│ └─md1                         9:1    0    2G  0 raid1
│   └─homework_VG-homework_LV 253:1    0  100M  0 lvm   /tmp/new
└─sdb2                          8:18   0  511M  0 part
  └─md2                         9:2    0 1017M  0 raid0
sdc                             8:32   0  2.5G  0 disk
├─sdc1                          8:33   0    2G  0 part
│ └─md1                         9:1    0    2G  0 raid1
│   └─homework_VG-homework_LV 253:1    0  100M  0 lvm   /tmp/new
└─sdc2                          8:34   0  511M  0 part
  └─md2                         9:2    0 1017M  0 raid0
```

17. Перевод sdc1 в состояние fail
```
vagrant@vagrant:/dev/homework_VG$ sudo mdadm /dev/md1 -f /dev/sdc1
mdadm: set /dev/sdc1 faulty in /dev/md1
vagrant@vagrant:/dev/homework_VG$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md2 : active raid0 sdc2[1] sdb2[0]
      1041408 blocks super 1.2 512k chunks

md1 : active raid1 sdc1[1](F) sdb1[0]
      2094080 blocks super 1.2 [2/1] [U_]

unused devices: <none>
```

18. Вывод dmesg
```
vagrant@vagrant:/dev/homework_VG$ dmesg | grep 'md1'
[ 7793.582801] md/raid1:md1: not clean -- starting background reconstruction
[ 7793.582802] md/raid1:md1: active with 2 out of 2 mirrors
[ 7793.582876] md1: detected capacity change from 0 to 2144337920
[ 7793.584075] md: resync of RAID array md1
[ 7803.911067] md: md1: resync done.
[10553.758265] md/raid1:md1: Disk failure on sdc1, disabling device.
               md/raid1:md1: Operation continuing on 1 devices.
```

19. Повторный тест архива
```
vagrant@vagrant:/dev/homework_VG$ gzip -t /tmp/new/test.gz
vagrant@vagrant:/dev/homework_VG$ echo $?
0
```



  