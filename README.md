Домашнее задание 3.4

1. Создается unit-файл для node-exporter\
sudo nano /etc/systemd/system/node_exporter.service

[Unit]\
Description=Node Exporter

[Service]

EnvironmentFile=/etc/sysconfig/node_exporter\
ExecStart=/usr/bin/prometheus-node-exporter $OPTION

[Install]\
WantedBy=multi-user.target

Создается файл опций

sudo mkdir /etc/sysconfig/\
sudo nano /etc/sysconfig/node_exporter\
OPTIONS=""

Далее перезапускается демон systemd/system/node_exporter\
sudo systemctl daemon-reload

Запускается сервис node_exporter\
sudo systemctl start node_exporter

Добавляется в автозагрузку\
sudo systemctl enable node_exporter

После перезагрузки:\
vagrant@vagrant:~$ sudo systemctl status node_exporter\
● node_exporter.service - Node Exporter\
     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)\
     Active: active (running) since Wed 2022-06-22 06:29:35 UTC; 1min 42s ago\
   Main PID: 619 (prometheus-node)\
      Tasks: 5 (limit: 1033)\
     Memory: 10.9M\
        CPU: 41ms\
     CGroup: /system.slice/node_exporter.service\
             └─619 /usr/bin/prometheus-node-exporter
			 
2. Вывод метрик можно посмотреть командой curl http://localhost:9100/metrics\
Для мониторинга хоста выбрал бы:\
node_cpu_seconds_total - время в секундах, затраченное центральным процессором в различных режимах\
node_disk_io_now - количество выполняемых в настоящее время дисковых операций ввода/вывода\
node_filesystem_size_bytes - размер разделов в байтах\
node_filesystem_avail_bytes - объем, доступный на разделах non-root пользователям\
node_filesystem_free_bytes - свободное место на разделах\
node_disk_read_bytes_total - всего считано байт с дисков\
node_disk_written_bytes_total - всего записано байт на диски\
node_memory_Cached_bytes - количество байт кэш\
node_memory_MemTotal_bytes - всего памяти в байтах\
node_memory_MemFree_bytes - свободно памяти в байтах\
node_network_receive_bytes_total - всего получено байт по сети\
node_network_transmit_bytes_total - всего отправлено байт по сети\

3. Основные отслеживаетмые метрики Netdata:\
Использование подкачки в %\
Запись на диск в МБ/с\
Чтение с диска в МБ/с\
Загрузка процессора в %\
Исходящий сетевой трафик в Мбит/с\
Входящий сетевой трафик в Мбит/с\
Использование ОЗУ в %

4. Можно определить командой sudo dmesg | grep -i virtual\
На реальном оборудовании выводится:\
Booting paravirtualized kernel on bare hardware\
На виртуальной машине:\
DMI: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006\
Booting paravirtualized kernel on KVM

5. vagrant@vagrant:~$ sysctl fs.nr_open\
fs.nr_open = 1048576 системный лимит на количество открытых дескрипторов\
Также в пределах текущей оболочке действует мягкий лимит\
vagrant@vagrant:~$ ulimit -Sn\
1024\
и жесткий лимит:\
vagrant@vagrant:~$ ulimit -Hn\
1048576

6. root@vagrant:~# unshare -f --pid --mount-proc sleep 1h&\
[1] 22442\
root@vagrant:~# ps aux | grep sleep\
root       22442  0.0  0.1   5768   996 pts/1    S    03:16   0:00 unshare -f --pid --mount-proc sleep 1h\
root       22443  0.0  0.1   5768  1020 pts/1    S    03:16   0:00 sleep 1h\
root       22445  0.0  0.2   6476  2284 pts/1    S+   03:16   0:00 grep --color=auto sleep\
root@vagrant:~# nsenter -t 22443 -p -m\
root@vagrant:/# ps\
    PID TTY          TIME CMD\
      1 pts/1    00:00:00 sleep\
      2 pts/1    00:00:00 bash\
     13 pts/1    00:00:00 ps

7. : (){ : |:& };: - fork-bomb\
Определяется функция с именем :, затем в {} идет тело функции, в котором она запускает сама себя и затем еще раз в фоне. ; завершает определение функции. Затем идет ее вызов.\
На виртуальной машине с Ubuntu 20.04 ситуация не нормализовалась после 30 минут ожидания. На реальной машине с Astra Linux 1.7 создание форков завершилось. \
Вывод dmesg:\
cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-3.scope\
В данном случае отработал cgroup - механизм ядра Linux, который ограничивает и изолирует вычислительные ресурсы (процессорные, сетевые, ресурсы памяти, ресурсы ввода-вывода) для групп процессов\
Скорее всего сработало ограничение на количество процессов пользователя. 

root@gu-kmv-a:/home/kmv/Desktops/Desktop1# systemctl status user-1000.slice\
● user-1000.slice - User Slice of UID 1000\
   Loaded: loaded\
  Drop-In: /usr/lib/systemd/system/user-.slice.d\
           └─10-defaults.conf\
   Active: active since Tue 2022-06-21 10:16:20 +05; 1 day 22h ago\
     Docs: man:user@.service(5)\
    Tasks: 299 (limit: 10813)\
   Memory: 1.2G\
   CGroup: /user.slice/user-1000.slice

 root@gu-kmv-a:/home/kmv/Desktops/Desktop1# cat /sys/fs/cgroup/pids/user.slice/user-1000.slice/pids.max \
10813
