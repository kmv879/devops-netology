# Домашнее задание к занятию "8.1. Введение в Ansible"

## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.

`some_fact` имеет значение 12.
 
```
vagrant@vagrant:/vagrant/playbook$ cat group_vars/all/examp.yml 
---
  some_fact: 12

vagrant@vagrant:/vagrant/playbook$ ansible-playbook -i inventory/test.yml  site.yml 

PLAY [Print os facts] *************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
ok: [localhost]

TASK [Print OS] *******************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *****************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP ************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```
2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.

```
vagrant@vagrant:/vagrant/playbook$ ansible-playbook -i inventory/test.yml  site.yml 

PLAY [Print os facts] *************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
ok: [localhost]

TASK [Print OS] *******************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *****************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP ************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.
```
vagrant@vagrant:/vagrant/playbook$ docker ps -a
CONTAINER ID   IMAGE                      COMMAND            CREATED          STATUS          PORTS     NAMES
ca2078e18cf0   pycontribs/ubuntu:latest   "sleep 60000000"   4 seconds ago    Up 3 seconds              ubuntu
f1d7db630405   pycontribs/centos:7        "sleep 60000000"   37 seconds ago   Up 36 seconds             centos7
```
4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.

```
vagrant@vagrant:/vagrant/playbook$ ansible-playbook -i inventory/prod.yml  site.yml 

PLAY [Print os facts] *************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host ubuntu should use /usr/bin/python3, but is using 
/usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using
 the discovered platform python for this host. See 
https://docs.ansible.com/ansible/2.10/reference_appendices/interpreter_discovery.html for more information. This 
feature will be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in
 ansible.cfg.
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *******************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *****************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP ************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.

```
---
  some_fact: "deb default fact"
```
```
---
  some_fact: "el default fact"
```
6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.
```
vagrant@vagrant:/vagrant/playbook$ ansible-playbook -i inventory/prod.yml  site.yml 

PLAY [Print os facts] *************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host ubuntu should use /usr/bin/python3, but is using 
/usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using
 the discovered platform python for this host. See 
https://docs.ansible.com/ansible/2.10/reference_appendices/interpreter_discovery.html for more information. This 
feature will be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in
 ansible.cfg.
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *******************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *****************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.

```
vagrant@vagrant:/vagrant/playbook$ ansible-vault encrypt group_vars/deb/examp.yml 
New Vault password: 
Confirm New Vault password: 
Encryption successful
vagrant@vagrant:/vagrant/playbook$ ansible-vault encrypt group_vars/el/examp.yml 
New Vault password: 
Confirm New Vault password: 
Encryption successful
vagrant@vagrant:/vagrant/playbook$ cat group_vars/deb/examp.yml 
$ANSIBLE_VAULT;1.1;AES256
37316436613962613766383961333733343265613537656635306163343538363664646533653732
6362303161626534626332663563333335643831323536350a633761343337663930363239373633
64323030326630343736383135346562353938383063353932656263323735666431393162393764
6662366336393565390a376263376539323938666431306137643031323661366137396135336435
37666265366238663834353664643437383631323861633737666433363732313138343964383738
6263343134666232323435353362386133666130396230313431
```

8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.

```
vagrant@vagrant:/vagrant/playbook$ ansible-playbook --ask-vault-password -i inventory/prod.yml  site.yml 
Vault password: 

PLAY [Print os facts] *************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host ubuntu should use /usr/bin/python3, but is using 
/usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using
 the discovered platform python for this host. See 
https://docs.ansible.com/ansible/2.10/reference_appendices/interpreter_discovery.html for more information. This 
feature will be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in
 ansible.cfg.
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *******************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *****************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.
```
vagrant@vagrant:/vagrant/playbook$ ansible-doc -t connection -l
```
```
local                          execute on controller
```
10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
```
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local
```
11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.

```
vagrant@vagrant:/vagrant/playbook$ ansible-playbook --ask-vault-password -i inventory/prod.yml  site.yml 
Vault password: 

PLAY [Print os facts] *************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
ok: [localhost]
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host ubuntu should use /usr/bin/python3, but is using 
/usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using
 the discovered platform python for this host. See 
https://docs.ansible.com/ansible/2.10/reference_appendices/interpreter_discovery.html for more information. This 
feature will be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in
 ansible.cfg.
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *******************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *****************************************************************************************************
ok: [localhost] => {
    "msg": "local default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.

```
vagrant@vagrant:/vagrant/playbook$ ansible-vault decrypt group_vars/el/examp.yml 
Vault password: 
Decryption successful
vagrant@vagrant:/vagrant/playbook$ ansible-vault decrypt group_vars/deb/examp.yml 
Vault password: 
Decryption successful
```
2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.
```
vagrant@vagrant:/vagrant/playbook$ ansible-vault encrypt_string
New Vault password: 
Confirm New Vault password: 
Reading plaintext input from stdin. (ctrl-d to end input, twice if your content does not already have a newline)
PaSSw0rd
!vault |
          $ANSIBLE_VAULT;1.1;AES256
          65363736633639346439333038306165386630346364616637656631323438323232636261663464
          6337656637656134356361653561383238386532386563330a313933653139656265393965323262
          33343632656639393437653533636236663265623436633862373035653539373063396630633732
          3838313362393832610a316264376166633262303639333333376264303638656364656333613536
          3531
Encryption successful
```
```
---
  some_fact1: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          65363736633639346439333038306165386630346364616637656631323438323232636261663464
          6337656637656134356361653561383238386532386563330a313933653139656265393965323262
          33343632656639393437653533636236663265623436633862373035653539373063396630633732
          3838313362393832610a316264376166633262303639333333376264303638656364656333613536
          3531
```


3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.

```
vagrant@vagrant:/vagrant/playbook$ ansible-playbook --ask-vault-password -i inventory/prod.yml  site.yml 
Vault password: 

PLAY [Print os facts] *************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
ok: [localhost]
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host ubuntu should use /usr/bin/python3, but is using 
/usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using
 the discovered platform python for this host. See 
https://docs.ansible.com/ansible/2.10/reference_appendices/interpreter_discovery.html for more information. This 
feature will be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in
 ansible.cfg.
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *******************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *****************************************************************************************************
ok: [localhost] => {
    "msg": "local default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

TASK [Print fact for all] *********************************************************************************************
ok: [localhost] => {
    "msg": "PaSSw0rd"
}
ok: [centos7] => {
    "msg": "PaSSw0rd"
}
ok: [ubuntu] => {
    "msg": "PaSSw0rd"
}

PLAY RECAP ************************************************************************************************************
centos7                    : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```

4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).
```
vagrant@vagrant:/vagrant/playbook$ ansible-playbook  -i inventory/prod.yml  site.yml 

PLAY [Print os facts] *************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
ok: [localhost]
ok: [fedora]
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host ubuntu should use /usr/bin/python3, but is using 
/usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using
 the discovered platform python for this host. See 
https://docs.ansible.com/ansible/2.10/reference_appendices/interpreter_discovery.html for more information. This 
feature will be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in
 ansible.cfg.
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *******************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [fedora] => {
    "msg": "Fedora"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *****************************************************************************************************
ok: [localhost] => {
    "msg": "local default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [fedora] => {
    "msg": "fedora default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
fedora                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
```
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  fed:
    hosts:
      fedora:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local
```

5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
```
#!/bin/bash
docker run  --name fedora -d pycontribs/fedora:latest sleep 60000000
docker run  --name centos7 -d pycontribs/centos:7 sleep 60000000
docker run  --name ubuntu -d pycontribs/ubuntu:latest sleep 60000000
ansible-playbook  -i ./playbook/inventory/prod.yml  ./playbook/site.yml
docker stop ubuntu > /dev/null && docker rm ubuntu > /dev/null
docker stop fedora > /dev/null && docker rm fedora > /dev/null
docker stop centos7 > /dev/null && docker rm centos7 > /dev/null
```
```
vagrant@vagrant:/vagrant$ ./start.sh 
65226bbed15881b7271dccc02ca772fba6d4ee2607dc61ca8dbf9aaa83172ee9
3ff911b847e7fb0641119025d930048296195b8d6538a971d91e6152fce35227
54a55e752b333ad85fc0e65bdf1b4b56de8583dc37acb4844460348031e9f04e

PLAY [Print os facts] *************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
ok: [fedora]
ok: [localhost]
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host ubuntu should use /usr/bin/python3, but is using 
/usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using
 the discovered platform python for this host. See 
https://docs.ansible.com/ansible/2.10/reference_appendices/interpreter_discovery.html for more information. This 
feature will be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in
 ansible.cfg.
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *******************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [fedora] => {
    "msg": "Fedora"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *****************************************************************************************************
ok: [localhost] => {
    "msg": "local default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [fedora] => {
    "msg": "fedora default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
fedora                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

vagrant@vagrant:/vagrant$ 

```
