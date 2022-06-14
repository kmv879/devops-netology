Занятие 3.3

1. vagrant@vagrant:~$ strace /bin/bash -c 'cd /tmp' 2>&1 | grep tmp  
execve("/bin/bash", ["/bin/bash", "-c", "cd /tmp"], 0x7ffc31cf2fa0 /* 23 vars */) = 0  
newfstatat(AT_FDCWD, "/tmp", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=4096, ...}, 0) = 0  
chdir("/tmp")  
Команда cd делает системный вызов chdir()

2. vagrant@vagrant:~$ strace file /bin/bash 2>&1 | grep open  
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3  
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libmagic.so.1", O_RDONLY|O_CLOEXEC) = 3  
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3  
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/liblzma.so.5", O_RDONLY|O_CLOEXEC) = 3  
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libbz2.so.1.0", O_RDONLY|O_CLOEXEC) = 3  
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libz.so.1", O_RDONLY|O_CLOEXEC) = 3  
openat(AT_FDCWD, "/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3  
openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)  
openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3  
openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3  
openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache", O_RDONLY) = 3  
openat(AT_FDCWD, "/bin/bash", O_RDONLY|O_NONBLOCK|O_CLOEXEC) = 3  
База данных команды file хранится в  /usr/share/misc/magic.mgc. /etc/magic пустой. Остальные файлы - системные библиотеки и кэш.

3. Узнать файловый дескриптор удаленного файла sudo lsof -p < PID> | grep deleted. Затем >/proc/< PID>/fd/< дескриптор>. Содержимое файла удаляется, но его размер, выдаваемый командой lsof продолжает расти, поэтому не понятен смысл данного действия.

4. Зомби-процессы не занимают памяти, но блокируют записи в таблице процессов, размер которой ограничен для каждого пользователя и системы в целом.

5. Список открытых файлов за 1 секунду  работы утилиты можно вывести командой sudo strace opensnoop-bpfcc -d 1 2>&1 | grep openat

6. Команда uname -a использует системный вызов uname()  
Цитата из man:  
Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}.

7. ; разделяет команды, которые выполняются последовательно. В случае && следующая команда выполняется только в случае успешного выполнения предыдущей.   
set -e обеспечивает немедленный выход, если выполняемая команда вернула ненулевой результат. В данном случае смысла в && нет.  

8. Опции bash set -euxo pipefail  
-e завершает работу скрипта, если команда выполняется с ошибкой  
-o pipefail позволяет проверить, что все команды в конвейере выполнились без ошибок. Без этой опции возращается результат выполнения последней команды конвейера  
-u завершает работу скрипта, если используемая в нем переменная не определена  
-x обеспечивает вывод выполняемой команды на стандартный вывод  
Параметры -euo прерывают работу скрипта при возникновении ошибок, а параметр -x полезен при отладке.  

9. vagrant@vagrant:~$ ps -o stat  
STAT  
Ss  
R+  
S - спящий прерываемый процесс  
R - выполняющийся процесс  
