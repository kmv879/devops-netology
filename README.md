# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | Будет выдано сообщение о неподдерживаемой операции между типами int и str  |
| Как получить для переменной `c` значение 12?  | c = int(str(a) + b)  |
| Как получить для переменной `c` значение 3?  | c = a + int(b)  |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print((os.popen('cd ~ && pwd').read())[:-1] + '/netology/sysadm-homeworks/' + prepare_result)
```

### Вывод скрипта при запуске при тестировании:
```
vagrant@vagrant:~$ python3 task1.py
/home/vagrant/netology/sysadm-homeworks/01-intro-01/README.md
/home/vagrant/netology/sysadm-homeworks/02-git-01-vcs/README.md
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os
import sys

if len(sys.argv) == 1:
    bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
    result_os = os.popen(' && '.join(bash_command)).read()
    for result in result_os.split('\n'):
        if result.find('modified') != -1:
            prepare_result = result.replace('\tmodified:   ', '')
            print((os.popen('cd ~ && pwd').read())[:-1] + '/netology/sysadm-homeworks/' + prepare_result)
else:
    path = sys.argv[1]
    if path[-1] != '/':
       path += '/'
    if not os.path.isdir(path + '.git'):
        print('\"' + path + '\"' + ' is not a git repository')
        exit()
    bash_command = ["cd " + path, "git status"]
    result_os = os.popen(' && '.join(bash_command)).read()
    for result in result_os.split('\n'):
        if result.find('modified') != -1:
            prepare_result = result.replace('\tmodified:   ', '')
            print(path + prepare_result)
```

### Вывод скрипта при запуске при тестировании:
```
vagrant@vagrant:~$ python3 task2.py
/home/vagrant/netology/sysadm-homeworks/01-intro-01/README.md
/home/vagrant/netology/sysadm-homeworks/02-git-01-vcs/README.md

vagrant@vagrant:~$ python3 task2.py  /home/vagrant/git/devops-netology
/home/vagrant/git/devops-netology/README.md

vagrant@vagrant:~$ python3 task2.py  /home/vagrant
"/home/vagrant/" is not a git repository
```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os
import socket

ip = dict.fromkeys(['drive.google.com', 'mail.google.com', 'google.com'])

#Проверка наличия файла с даными прошлых проверок. Если файл существует,
#старые IP записываются в словарь ip.
if os.path.isfile('./data'):
    with open('./data', 'r') as f:
        ip_data = f.read().splitlines()
    for i in ip_data:
        ip[i.split(':')[0]]=i.split(':')[1]

#Для каждого URL из словаря определяется IP адрес. Если адрес совпадает с адресом прошлой проверки,
#или данных о прошлых проверках нет, выводится сообщение формата <URL сервиса> - <его IP>.
#В противном случае выводится сообщение формата [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>
#Далее в словарь записывается новый IP сервиса
for i in ip.items():
    new_ip = socket.gethostbyname(i[0])
    if new_ip ==  i[1] or not i[1]:
        print(i[0]+' - '+new_ip)
    else:
        print('[ERROR] '+i[0]+' IP mismatch: '+i[1]+' '+new_ip)
    ip[i[0]]=new_ip
#Данные о проверке записываются в файл в виде <URL сервиса>:<IP адрес>
with open ('./data', 'w') as f:
    for i in ip.items():
         f.write(i[0]+':'+i[1]+'\n')
```

### Вывод скрипта при запуске при тестировании:
```
vagrant@vagrant:~$ python3 task3.py
drive.google.com - 74.125.131.194
mail.google.com - 216.58.209.165
google.com - 216.58.209.174
vagrant@vagrant:~$ cp data1 data
vagrant@vagrant:~$ python3 task3.py
[ERROR] drive.google.com IP mismatch: 1.0.0.0 74.125.131.194
[ERROR] mail.google.com IP mismatch: 0.2.0.0 216.58.209.165
[ERROR] google.com IP mismatch: 0.0.3.0 216.58.209.174
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так получилось, что мы очень часто вносим правки в конфигурацию своей системы прямо на сервере. Но так как вся наша команда разработки держит файлы конфигурации в github и пользуется gitflow, то нам приходится каждый раз переносить архив с нашими изменениями с сервера на наш локальный компьютер, формировать новую ветку, коммитить в неё изменения, создавать pull request (PR) и только после выполнения Merge мы наконец можем официально подтвердить, что новая конфигурация применена. Мы хотим максимально автоматизировать всю цепочку действий. Для этого нам нужно написать скрипт, который будет в директории с локальным репозиторием обращаться по API к github, создавать PR для вливания текущей выбранной ветки в master с сообщением, которое мы вписываем в первый параметр при обращении к py-файлу (сообщение не может быть пустым). При желании, можно добавить к указанному функционалу создание новой ветки, commit и push в неё изменений конфигурации. С директорией локального репозитория можно делать всё, что угодно. Также, принимаем во внимание, что Merge Conflict у нас отсутствуют и их точно не будет при push, как в свою ветку, так и при слиянии в master. Важно получить конечный результат с созданным PR, в котором применяются наши изменения. 

### Ваш скрипт:
```python
???
```

### Вывод скрипта при запуске при тестировании:
```
???
```