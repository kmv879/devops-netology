# Домашнее задание к занятию "2. Работа с Playbook"

## Подготовка к выполнению

1. (Необязательно) Изучите, что такое [clickhouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [vector](https://www.youtube.com/watch?v=CgEhyffisLY)
2. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

## Основная часть

1. Приготовьте свой собственный inventory файл `prod.yml`.

```
---
clickhouse:
  hosts:
    clickhouse-01:
      ansible_host: 192.168.1.52
vector:
  hosts:    
    vector-01:
      ansible_host: 192.168.1.104
```
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, установить vector.
```
---
- name: Install Clickhouse
  hosts: clickhouse
  handlers:
    - name: Start clickhouse service
      become: true
      ansible.builtin.service:
        name: clickhouse-server
        state: restarted
  tasks:
    - block:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/{{ item }}-{{ clickhouse_version }}.noarch.rpm"
            dest: "/tmp/{{ item }}-{{ clickhouse_version }}.rpm"
          with_items: "{{ clickhouse_packages }}"
      rescue:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-{{ clickhouse_version }}.x86_64.rpm"
            dest: "/tmp/clickhouse-common-static-{{ clickhouse_version }}.rpm"
    - name: Install clickhouse packages
      become: true
      ansible.builtin.yum:
        name:
          - /tmp/clickhouse-common-static-{{ clickhouse_version }}.rpm
          - /tmp/clickhouse-client-{{ clickhouse_version }}.rpm
          - /tmp/clickhouse-server-{{ clickhouse_version }}.rpm
      notify: Start clickhouse service
    - name: Flush handlers
      meta: flush_handlers
    - name: Wait for port 9000 to become open on the host, don't start checking for 10 seconds
      wait_for:
        port: 9000
        delay: 10
    - name: Create database
      ansible.builtin.command: "clickhouse-client -q 'create database {{ clickhouse_database_name }};'"
      register: create_db
      failed_when: create_db.rc != 0 and create_db.rc !=82
      changed_when: create_db.rc == 0
    - name: Create log table
      ansible.builtin.command:
        argv:
          - clickhouse-client
          - --database
          - "{{ clickhouse_database_name }}"
          - -q
          - "{{ clickhouse_create_table }}"
      register: create_table
      failed_when: create_table.rc != 0 and create_table.rc !=57 # table already exists
      changed_when: create_table.rc == 0
- name: Install Vector
  hosts: vector
  handlers:
    - name: Start Vector service
      become: true
      ansible.builtin.service:
        name: vector
        state: restarted
  tasks:
    - name: Get vector distrib
      ansible.builtin.get_url:
        url: "https://packages.timber.io/vector/{{ vector_version }}/vector-{{ vector_version }}-1.x86_64.rpm"
        dest: "/tmp/vector-{{ vector_version }}.rpm"
    - name: Install vector package
      become: true
      ansible.builtin.yum:
        name:
          - /tmp/vector-{{ vector_version }}.rpm
    - name: Create vector config
      become: true
      ansible.builtin.copy:
        dest: /etc/vector/config.yaml
        content: "{{ vector_config | to_nice_yaml(indent=2) }}"
        mode: u=rw,g=r,o=r
      notify: Start Vector service
    - name: Flush handlers
      meta: flush_handlers
```
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
```
vagrant@vagrant:/vagrant/playbook$ ansible-lint site.yml 
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
vagrant@vagrant:/vagrant/playbook$ 
```

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
```
vagrant@vagrant:/vagrant/playbook$ ansible-playbook --check -i inventory/prod.yml site.yml 

PLAY [Install Clickhouse] ******************************************************

TASK [Gathering Facts] *********************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] **************************************************
changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "/tmp/clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] **************************************************
changed: [clickhouse-01]

TASK [Install clickhouse packages] *********************************************
fatal: [clickhouse-01]: FAILED! => {"changed": false, "msg": "No RPM file matching '/tmp/clickhouse-common-static-22.3.3.44.rpm' found on system", "rc": 127, "results": ["No RPM file matching '/tmp/clickhouse-common-static-22.3.3.44.rpm' found on system"]}

PLAY RECAP *********************************************************************
clickhouse-01              : ok=2    changed=1    unreachable=0    failed=1    skipped=0    rescued=1    ignored=0   

vagrant@vagrant:/vagrant/playbook$
```
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
```
vagrant@vagrant:/vagrant/playbook$ ansible-playbook --diff -i inventory/prod.yml site.yml 

PLAY [Install Clickhouse] ******************************************************

TASK [Gathering Facts] *********************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] **************************************************
changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "/tmp/clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] **************************************************
changed: [clickhouse-01]

TASK [Install clickhouse packages] *********************************************
changed: [clickhouse-01]

RUNNING HANDLER [Start clickhouse service] *************************************
changed: [clickhouse-01]

TASK [Wait for port 9000 to become open on the host, don't start checking for 10 seconds] ***
ok: [clickhouse-01]

TASK [Create database] *********************************************************
changed: [clickhouse-01]

TASK [Create log table] ********************************************************
changed: [clickhouse-01]

PLAY [Install Vector] **********************************************************

TASK [Gathering Facts] *********************************************************
ok: [vector-01]

TASK [Get vector distrib] ******************************************************
changed: [vector-01]

TASK [Install vector package] **************************************************
changed: [vector-01]

TASK [Create vector config] ****************************************************
--- before
+++ after: /home/vagrant/.ansible/tmp/ansible-local-9474evfms5s8/tmpdejapj0r
@@ -0,0 +1,17 @@
+sinks:
+  to_clickhouse:
+    compression: gzip
+    database: logs
+    endpoint: http://192.168.1.52:8123
+    inputs:
+    - sample_logs
+    table: log
+    type: clickhouse
+sources:
+  sample_logs:
+    acknowledgements: null
+    ignore_older_secs: 600
+    include:
+    - /var/log/**/*.log
+    read_from: beginning
+    type: file

changed: [vector-01]

RUNNING HANDLER [Start Vector service] *****************************************
changed: [vector-01]

PLAY RECAP *********************************************************************
clickhouse-01              : ok=7    changed=5    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
vector-01                  : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
```
vagrant@vagrant:/vagrant/playbook$ ansible-playbook --diff -i inventory/prod.yml site.yml 

PLAY [Install Clickhouse] ******************************************************

TASK [Gathering Facts] *********************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] **************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "/tmp/clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 1000, "group": "vagrant", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "vagrant", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 1000, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] **************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] *********************************************
ok: [clickhouse-01]

TASK [Wait for port 9000 to become open on the host, don't start checking for 10 seconds] ***
ok: [clickhouse-01]

TASK [Create database] *********************************************************
ok: [clickhouse-01]

TASK [Create log table] ********************************************************
ok: [clickhouse-01]

PLAY [Install Vector] **********************************************************

TASK [Gathering Facts] *********************************************************
ok: [vector-01]

TASK [Get vector distrib] ******************************************************
ok: [vector-01]

TASK [Install vector package] **************************************************
ok: [vector-01]

TASK [Create vector config] ****************************************************
ok: [vector-01]

PLAY RECAP *********************************************************************
clickhouse-01              : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
vector-01                  : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

vagrant@vagrant:/vagrant/playbook$
```

9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

Playbook скачивает и устанавливает пакеты clickhouse, ожидает доступности порта 9000 и затем создает базу и таблицу в ней. Затем скачивается, устанавливаетсяи конфигурируется vector.
В group_vars clickhouse настраиваются версия, инсталлируемые пакеты, имя базы данных и структура таблицы для vector. В group_vars vector настраивается версия пакета и состав конфигурационного файла.

10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.


---
