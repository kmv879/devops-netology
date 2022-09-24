# Домашнее задание к занятию "5.5. Оркестрация кластером Docker контейнеров на примере Docker Swarm"

## Задача 1

Дайте письменые ответы на следующие вопросы:

- В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global? - в режиме replication сервис реплицируется на указанное количество нод, в режиме global - на все.
- Какой алгоритм выбора лидера используется в Docker Swarm кластере? - используется алгоритм поддержания распределенного консенсуса — Raft
- Что такое Overlay Network? - виртуальная сеть, работающая поверх физической

## Задача 2

Создать ваш первый Docker Swarm кластер в Яндекс.Облаке

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker node ls
```
```
kmv@kmv-note:~/git/netology/virt-homeworks/05-virt-05-docker-swarm/src/terraform$ ssh -A centos@51.250.90.228
[centos@node01 ~]$ sudo docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
fngbqo80ngh9suackwqn76onp *   node01.netology.yc   Ready     Active         Leader           20.10.18
psx8d8v0nhbbohip3unclgk87     node02.netology.yc   Ready     Active         Reachable        20.10.18
3sqb06jpb7uo93f7erp9oht85     node03.netology.yc   Ready     Active         Reachable        20.10.18
pkp12kwonlszuuq8slsmvkc5e     node04.netology.yc   Ready     Active                          20.10.18
q8ve9ec35e3ueah7yjf7nekk3     node05.netology.yc   Ready     Active                          20.10.18
yim5t7paaszhw1cql5v03m9bs     node06.netology.yc   Ready     Active                          20.10.18
```

## Задача 3

Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker service ls
```
```
[centos@node01 ~]$ sudo docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
t1roalzw0b7a   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0    
v7e11g50paf3   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
n5qu9uyinurg   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest                         
tok1bvcl3wft   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest                      
4kf0g6akrxjq   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4           
jecut2t24725   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0   
db05liilan3y   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0       
o04ouz0s72ke   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0 
```
## Задача 4 (*)

Выполнить на лидере Docker Swarm кластера команду (указанную ниже) и дать письменное описание её функционала, что она делает и зачем она нужна:
```
# см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/
docker swarm update --autolock=true
```
```
[centos@node01 ~]$ sudo docker swarm update --autolock=true
Swarm updated.
To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:
```
Дання команда применяется для блокировки роя с целью защиты ключа шифрования TLS  и ключа, используемого для шифрования и расшифровки журналов Raft. 

