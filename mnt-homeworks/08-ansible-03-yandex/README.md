# Домашнее задание к занятию "3. Использование Yandex Cloud"

## Подготовка к выполнению

1. Подготовьте в Yandex Cloud три хоста: для `clickhouse`, для `vector` и для `lighthouse`.

Ссылка на репозиторий LightHouse: https://github.com/VKCOM/lighthouse

## Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает lighthouse.
2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
3. Tasks должны: скачать статику lighthouse, установить nginx или любой другой webserver, настроить его конфиг для открытия lighthouse, запустить webserver.
4. Приготовьте свой собственный inventory файл `prod.yml`.

Файл `prod.yml` создает terraform после создания виртуальных машин в Yandex cloud и получения их IP адресов.
```
resource "local_file" "inventory" {
  content = <<-DOC
    # Ansible inventory containing variable values from Terraform.
    # Generated by Terraform.
    ---
    clickhouse:
      hosts:
        clickhouse-01:
          ansible_host: ${yandex_compute_instance.node01.network_interface.0.nat_ip_address}
    vector:
      hosts:    
        vector-01:
          ansible_host: ${yandex_compute_instance.node02.network_interface.0.nat_ip_address}
    lighthouse:
      hosts:    
        lighthouse-01:
          ansible_host: ${yandex_compute_instance.node03.network_interface.0.nat_ip_address}    

    DOC
  filename = "../ansible/inventory/prod.yml"

  depends_on = [
    yandex_compute_instance.node01,
    yandex_compute_instance.node02,
    yandex_compute_instance.node03
  ]
}
```

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

```
kmv@kmv-note:~/git/devops-netology/mnt-homeworks/08-ansible-03-yandex/src/ansible$ ansible-lint site.yml 
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
kmv@kmv-note:~/git/devops-netology/mnt-homeworks/08-ansible-03-yandex/src/ansible$
```
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

playbook с ключем --check завершает работу с ошибкой, так как скачивание пакетов не производилось.

```
kmv@kmv-note:~/git/devops-netology/mnt-homeworks/08-ansible-03-yandex/src/ansible$ ansible-playbook -i inventory/prod.yml --check site.yml 

PLAY [Install Clickhouse] *********************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] *****************************************************************************************
changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "/tmp/clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] *****************************************************************************************
changed: [clickhouse-01]

TASK [Install clickhouse packages] ************************************************************************************
fatal: [clickhouse-01]: FAILED! => {"changed": false, "msg": "No RPM file matching '/tmp/clickhouse-common-static-22.3.3.44.rpm' found on system", "rc": 127, "results": ["No RPM file matching '/tmp/clickhouse-common-static-22.3.3.44.rpm' found on system"]}

PLAY RECAP ************************************************************************************************************
clickhouse-01              : ok=2    changed=1    unreachable=0    failed=1    skipped=0    rescued=1    ignored=0   

kmv@kmv-note:~/git/devops-netology/mnt-homeworks/08-ansible-03-yandex/src/ansible$
```

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
```
null_resource.ansible (local-exec): PLAY [Install Clickhouse] ******************************************************

null_resource.ansible (local-exec): TASK [Gathering Facts] *********************************************************
null_resource.ansible (local-exec): ok: [clickhouse-01]

null_resource.ansible (local-exec): TASK [Get clickhouse distrib] **************************************************
null_resource.ansible (local-exec): changed: [clickhouse-01] => (item=clickhouse-client)
null_resource.ansible: Still creating... [10s elapsed]
null_resource.ansible (local-exec): changed: [clickhouse-01] => (item=clickhouse-server)
null_resource.ansible (local-exec): failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "/tmp/clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

null_resource.ansible (local-exec): TASK [Get clickhouse distrib] **************************************************
null_resource.ansible (local-exec): changed: [clickhouse-01]

null_resource.ansible (local-exec): TASK [Install clickhouse packages] *********************************************
null_resource.ansible: Still creating... [20s elapsed]
null_resource.ansible: Still creating... [30s elapsed]
null_resource.ansible: Still creating... [40s elapsed]
null_resource.ansible: Still creating... [50s elapsed]
null_resource.ansible (local-exec): changed: [clickhouse-01]

null_resource.ansible (local-exec): RUNNING HANDLER [Start clickhouse service] *************************************
null_resource.ansible: Still creating... [1m0s elapsed]
null_resource.ansible (local-exec): changed: [clickhouse-01]

null_resource.ansible (local-exec): TASK [Wait for port 9000 to become open on the host, don't start checking for 10 seconds] ***
null_resource.ansible: Still creating... [1m10s elapsed]
null_resource.ansible (local-exec): ok: [clickhouse-01]

null_resource.ansible (local-exec): TASK [Create database] *********************************************************
null_resource.ansible (local-exec): changed: [clickhouse-01]

null_resource.ansible (local-exec): TASK [Create log table] ********************************************************
null_resource.ansible (local-exec): changed: [clickhouse-01]

null_resource.ansible (local-exec): PLAY [Install Vector] **********************************************************

null_resource.ansible (local-exec): TASK [Gathering Facts] *********************************************************
null_resource.ansible: Still creating... [1m20s elapsed]
null_resource.ansible (local-exec): ok: [vector-01]

null_resource.ansible (local-exec): TASK [Get vector distrib] ******************************************************
null_resource.ansible (local-exec): changed: [vector-01]

null_resource.ansible (local-exec): TASK [Install vector package] **************************************************
null_resource.ansible: Still creating... [1m30s elapsed]
null_resource.ansible (local-exec): changed: [vector-01]

null_resource.ansible (local-exec): TASK [Create vector config] ****************************************************
null_resource.ansible: Still creating... [1m40s elapsed]
null_resource.ansible (local-exec): --- before
null_resource.ansible (local-exec): +++ after: /home/kmv/.ansible/tmp/ansible-local-2259739zmjiqm4/tmp6ri79rvu
null_resource.ansible (local-exec): @@ -0,0 +1,17 @@
null_resource.ansible (local-exec): +sinks:
null_resource.ansible (local-exec): +  to_clickhouse:
null_resource.ansible (local-exec): +    compression: gzip
null_resource.ansible (local-exec): +    database: logs
null_resource.ansible (local-exec): +    endpoint: http://192.168.1.52:8123
null_resource.ansible (local-exec): +    inputs:
null_resource.ansible (local-exec): +    - sample_logs
null_resource.ansible (local-exec): +    table: log
null_resource.ansible (local-exec): +    type: clickhouse
null_resource.ansible (local-exec): +sources:
null_resource.ansible (local-exec): +  sample_logs:
null_resource.ansible (local-exec): +    acknowledgements: null
null_resource.ansible (local-exec): +    ignore_older_secs: 600
null_resource.ansible (local-exec): +    include:
null_resource.ansible (local-exec): +    - /var/log/**/*.log
null_resource.ansible (local-exec): +    read_from: beginning
null_resource.ansible (local-exec): +    type: file
null_resource.ansible (local-exec): 
null_resource.ansible (local-exec): changed: [vector-01]

null_resource.ansible (local-exec): RUNNING HANDLER [Start Vector service] *****************************************
null_resource.ansible (local-exec): changed: [vector-01]

null_resource.ansible (local-exec): PLAY [Install lighthouse] ******************************************************

null_resource.ansible (local-exec): TASK [Gathering Facts] *********************************************************
null_resource.ansible (local-exec): ok: [lighthouse-01]

null_resource.ansible (local-exec): TASK [Install packages] ********************************************************
null_resource.ansible: Still creating... [1m50s elapsed]
null_resource.ansible: Still creating... [2m0s elapsed]
null_resource.ansible: Still creating... [2m10s elapsed]
null_resource.ansible (local-exec): changed: [lighthouse-01]

null_resource.ansible (local-exec): TASK [Install nginx] ***********************************************************
null_resource.ansible: Still creating... [2m20s elapsed]
null_resource.ansible (local-exec): changed: [lighthouse-01]

null_resource.ansible (local-exec): TASK [clone lighthouse repo] ***************************************************
null_resource.ansible: Still creating... [2m30s elapsed]
null_resource.ansible (local-exec): >> Newly checked out d701335c25cd1bb9b5155711190bad8ab852c2ce
null_resource.ansible (local-exec): changed: [lighthouse-01]

null_resource.ansible (local-exec): RUNNING HANDLER [Start nginx service] ******************************************
null_resource.ansible (local-exec): changed: [lighthouse-01]

null_resource.ansible (local-exec): PLAY RECAP *********************************************************************
null_resource.ansible (local-exec): clickhouse-01              : ok=7    changed=5    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
null_resource.ansible (local-exec): lighthouse-01              : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
null_resource.ansible (local-exec): vector-01                  : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

null_resource.ansible: Creation complete after 2m31s [id=5837163371670258061]

Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_node01 = "84.201.135.27"
external_ip_address_node02 = "51.250.87.189"
external_ip_address_node03 = "51.250.84.79"
internal_ip_address_node01 = "192.168.101.11"
internal_ip_address_node02 = "192.168.101.12"
internal_ip_address_node03 = "192.168.101.13"
```
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

```
kmv@kmv-note:~/git/devops-netology/mnt-homeworks/08-ansible-03-yandex/src/ansible$ ansible-playbook -i inventory/prod.yml --diff site.yml 

PLAY [Install Clickhouse] *********************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] *****************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "/tmp/clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] *****************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] ************************************************************************************
ok: [clickhouse-01]

TASK [Wait for port 9000 to become open on the host, don't start checking for 10 seconds] *****************************
ok: [clickhouse-01]

TASK [Create database] ************************************************************************************************
ok: [clickhouse-01]

TASK [Create log table] ***********************************************************************************************
ok: [clickhouse-01]

PLAY [Install Vector] *************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
ok: [vector-01]

TASK [Get vector distrib] *********************************************************************************************
ok: [vector-01]

TASK [Install vector package] *****************************************************************************************
ok: [vector-01]

TASK [Create vector config] *******************************************************************************************
ok: [vector-01]

PLAY [Install lighthouse] *********************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
ok: [lighthouse-01]

TASK [Install packages] ***********************************************************************************************
ok: [lighthouse-01]

TASK [Install nginx] **************************************************************************************************
ok: [lighthouse-01]

TASK [clone lighthouse repo] ******************************************************************************************
ok: [lighthouse-01]

PLAY RECAP ************************************************************************************************************
clickhouse-01              : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
lighthouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

kmv@kmv-note:~/git/devops-netology/mnt-homeworks/08-ansible-03-yandex/src/ansible$ 
```
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

Playbook скачивает и устанавливает пакеты clickhouse, ожидает доступности порта 9000 и затем создает базу и таблицу в ней. Затем скачивается, устанавливаетсяи конфигурируется vector. Далее устанавливается nginx и клонируется репозиторий lighthouse в папку вебсервера.
В group_vars clickhouse настраиваются версия, инсталлируемые пакеты, имя базы данных и структура таблицы для vector. В group_vars vector настраивается версия пакета и состав конфигурационного файла.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---

