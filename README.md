# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис   
  Исправленный файл. Также вместо первого ip выводится числовое значение.
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            },
            { "name" : "second",
            "type" : "proxy",
            "ip" : "71.78.22.43"
            }
        ]
    }
```
## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os
import socket
import json
import yaml

ip = [{'drive.google.com':''}, {'mail.google.com':''}, {'google.com':''}]

#Проверка наличия файла с даными прошлых проверок. Если файл существует,
#старые IP записываются в ip.
if os.path.isfile('./data.json'):
    with open ('./data.json', 'r') as f:
        ip_data = json.load(f)
    ip = ip_data
elif os.path.isfile('./data.yml'):
    with open ('./data.yml', 'r') as f:
        ip_data = yaml.safe_load(f)
    ip = ip_data

#Для каждого URL определяется IP адрес. Если адрес совпадает с адресом прошлой проверки,
#или данных о прошлых проверках нет, выводится сообщение формата <URL сервиса> - <его IP>.
#В противном случае выводится сообщение формата [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>

for i in ip:
     address = list(i.keys())[0]
     new_ip = socket.gethostbyname(address)
     if new_ip ==  i[address] or not i[address]:
        print(address + ' - ' + new_ip)
     else:
        print('[ERROR] '+ address +' IP mismatch: ' + i[address] + ' ' + new_ip)
     i[address] = new_ip
#Данные о проверке записываются в файл в виде <URL сервиса>:<IP адрес>
with open ('./data.json', 'w') as f:
     json.dump(ip,f, indent=4)
with open ('./data.yml', 'w') as f:
     yaml.dump(ip,f)
```

### Вывод скрипта при запуске при тестировании:
```
vagrant@vagrant:~$ python3 task42.py
[ERROR] drive.google.com IP mismatch: 174.125.131.194 74.125.131.194
[ERROR] mail.google.com IP mismatch: 10.58.209.165 216.58.209.165
[ERROR] google.com IP mismatch: 10.58.209.1 216.58.209.174
vagrant@vagrant:~$ python3 task42.py
drive.google.com - 74.125.131.194
mail.google.com - 216.58.209.165
google.com - 216.58.209.174
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
[
    {
        "drive.google.com": "74.125.131.194"
    },
    {
        "mail.google.com": "216.58.209.165"
    },
    {
        "google.com": "216.58.209.174"
    }
]
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
- drive.google.com: 74.125.131.194
- mail.google.com: 216.58.209.165
- google.com: 216.58.209.174
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так как команды в нашей компании никак не могут прийти к единому мнению о том, какой формат разметки данных использовать: JSON или YAML, нам нужно реализовать парсер из одного формата в другой. Он должен уметь:
   * Принимать на вход имя файла
   * Проверять формат исходного файла. Если файл не json или yml - скрипт должен остановить свою работу
   * Распознавать какой формат данных в файле. Считается, что файлы *.json и *.yml могут быть перепутаны
   * Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)
   * При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер
   * Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os
import sys
import json
import yaml

#Проверка наличия имени файла в качестве аргумента
if len(sys.argv) == 1:
    print('File name not specified')
    exit()
#Проверка наличия указанного файла
if not os.path.isfile(sys.argv[1]):
    print('The specified file does not exist: ' + sys.argv[1])
    exit()
file_ext = sys.argv[1][(sys.argv[1]).rfind('.') + 1::]
file_name = sys.argv[1][0:(sys.argv[1]).rfind('.')]
#Проверка формата файла
if file_ext.lower() != 'json' and file_ext.lower() != 'yml':
    print('Invalid file format: ' + sys.argv[1])
    exit()
with open(file_name + '.' + file_ext, 'r') as file:
   data = file.read().strip()
#Если содержимое файла начинается с { или [, считается, что формат файла JSON
if data[0] == '{' or data[0] == '[':
   try:
       python_data=json.loads(data)
       if file_ext == 'yml': #Если перепутано расширение, к имени файла добавляется _copy
           file_name += '_copy'
       with open(file_name + '.' + 'yml', 'w') as outfile:
           yaml.dump(python_data, outfile)
           print(sys.argv[1] + ' (JSON format) converted to ' + file_name + '.' + 'yml')
   except json.decoder.JSONDecodeError as err:
       errstr=str(err)[str(err).find('line') + 5:str(err).find('column') - 1]
       print('Ошибка в строке ' + errstr + ':\n'+ data.split('\n')[int(errstr)-1].strip())
else: #Обработка YML
    try:
        python_data=yaml.safe_load(data)
        if file_ext == 'json':
           file_name += '_copy'
        with open(file_name + '.' + 'json', 'w') as outfile:
           json.dump(python_data, outfile, indent = 4)
           print(sys.argv[1] + ' (YML format) converted to ' + file_name + '.' + 'json')
    except yaml.parser.ParserError as err:
        errstr=str(err)[str(err).find('line') + 5:str(err).find('column') - 2]
        print('Ошибка в строке ' + errstr + ':\n'+ data.split('\n')[int(errstr)-1].strip())
```

### Пример работы скрипта:
```
vagrant@vagrant:~$ python3 task43.py
File name not specified
vagrant@vagrant:~$ python3 task43.py 1.jso
The specified file does not exist: 1.jso
vagrant@vagrant:~$ python3 task43.py 1.json
1.json (JSON format) converted to 1.yml
```

### исходный json-файл:
```json
{
    "elements": [
        {
            "ip": 7175,
            "name": "first",
            "type": "server"
        },
        {
            "ip": "71.78.22.43",
            "name": "second",
            "type": "proxy"
        }
    ]
 }
```

### сформированный yml-файл:
```yaml
elements:
- ip: 7175
  name: first
  type: server
- ip: 71.78.22.43
  name: second
  type: proxy
```