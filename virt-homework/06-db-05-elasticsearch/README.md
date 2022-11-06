# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

```
FROM centos:7

EXPOSE 9200 9300

USER 0

RUN export ES_HOME="/var/lib/elasticsearch" && \
    yum -y install wget && \
    wget https://fossies.org/linux/www/elasticsearch-7.17.7-linux-x86_64.tar.gz && \
    tar -xzf elasticsearch-7.17.7-linux-x86_64.tar.gz && \
    rm -f elasticsearch-7.17.7-linux-x86_64.tar.gz* && \
    mv elasticsearch-7.17.7 ${ES_HOME} && \
    useradd -m -u 1000 elasticsearch && \
    chown elasticsearch:elasticsearch -R ${ES_HOME} && \
    yum -y remove wget && \
    yum clean all

COPY --chown=elasticsearch:elasticsearch config/* /var/lib/elasticsearch/config/
    
USER 1000

ENV ES_HOME="/var/lib/elasticsearch" \
    ES_PATH_CONF="/var/lib/elasticsearch/config" 
    
WORKDIR ${ES_HOME}

CMD ["sh", "-c", "${ES_HOME}/bin/elasticsearch"]
```

```
[root@testdb docker]# docker build -t kmv879/elasticsearch:7.17.7 .
[root@testdb docker]# docker run --rm -d --name elasticsearch  -p 9200:9200 -p 9300:9300 kmv879/elasticsearch:7.17.7
[root@testdb docker]# docker ps
CONTAINER ID   IMAGE                         COMMAND                  CREATED         STATUS         PORTS                                                                                  NAMES
fc4820351372   kmv879/elasticsearch:7.17.7   "sh -c ${ES_HOME}/bi…"   6 minutes ago   Up 6 minutes   0.0.0.0:9200->9200/tcp, :::9200->9200/tcp, 0.0.0.0:9300->9300/tcp, :::9300->9300/tcp   elasticsearch
[root@testdb docker]# curl -X GET 'localhost:9200/'
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "Fq2U1x7XRQeIfID7cofFsA",
  "version" : {
    "number" : "7.17.7",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "78dcaaa8cee33438b91eca7f5c7f56a70fec9e80",
    "build_date" : "2022-10-17T15:29:54.167373105Z",
    "build_snapshot" : false,
    "lucene_version" : "8.11.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```

[Ссылка на hub.docker.com](https://hub.docker.com/repository/docker/kmv879/elasticsearch)

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

```
[root@testdb docker]# curl -X PUT "localhost:9200/ind-1?pretty" -H 'Content-Type: application/json' -d'
{
   "settings": {
     "number_of_shards": 1,
     "number_of_replicas": 0
   }
}
'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-1"
}
[root@testdb docker]# curl -X PUT "localhost:9200/ind-2?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 2,
    "number_of_replicas": 1
  }
}
'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-2"
}
[root@testdb docker]# curl -X PUT "localhost:9200/ind-3?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 4,
    "number_of_replicas": 2
  }
}
'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-3"
}
```


Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

```
[root@testdb docker]# curl -X GET "localhost:9200/_cat/indices?v"
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases ojkVfGO-Qb6AT1Ew3GZ_Xg   1   0         40            0     38.4mb         38.4mb
green  open   ind-1            j2gQlyS-Rua2I4S6Th0S4g   1   0          0            0       226b           226b
yellow open   ind-3            EEIuHL2URYOsKA0dSlyycw   4   2          0            0       904b           904b
yellow open   ind-2            ndOS9O--SMSf4KPxSyK5YQ   2   1          0            0       452b           452b
```
Получите состояние кластера `elasticsearch`, используя API.

```
[root@testdb docker]# curl -X GET "localhost:9200/_cluster/health?pretty"
{
  "cluster_name" : "elasticsearch",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 10,
  "active_shards" : 10,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}

```

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Для второго и третьего индексов не может быть создано реплик, потому что нода одна, поэтому состояние интексов и кластера yellow.

Удалите все индексы.

```
[root@testdb docker]# curl -X DELETE 'http://localhost:9200/_all'
{"acknowledged":true}
```

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

```
[elasticsearch@31321bf0f304 elasticsearch]$ mkdir snapshots
```

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

```
[elasticsearch@31321bf0f304 elasticsearch]$ echo path.repo: [ "/var/lib/elasticsearch/snapshots" ] >> "$ES_HOME/config/elasticsearch.yml"
[root@testdb docker]# docker restart elasticsearch
[root@testdb docker]# curl -X PUT "localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/var/lib/elasticsearch/snapshots",
    "compress": true
  }
}'
{
  "acknowledged" : true
}
```
Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.
```
[root@testdb docker]# curl -X PUT "localhost:9200/test?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  }
}
'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test"
}
[root@testdb docker]# curl -X GET "localhost:9200/_cat/indices?v"
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases ojkVfGO-Qb6AT1Ew3GZ_Xg   1   0         40            0     38.4mb         38.4mb
green  open   test             vjHoA5A6QTye8zI-Qm6ruw   1   0          0            0       226b           226b
```

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

```
[root@testdb docker]# curl -X PUT "localhost:9200/_snapshot/netology_backup/snapshot_1?wait_for_completion=true&pretty"
{
  "snapshot" : {
    "snapshot" : "snapshot_1",
    "uuid" : "sublyLIQTA-YzLeP8W6InQ",
    "repository" : "netology_backup",
    "version_id" : 7170799,
    "version" : "7.17.7",
    "indices" : [
      ".ds-.logs-deprecation.elasticsearch-default-2022.11.06-000001",
      "test",
      ".geoip_databases",
      ".ds-ilm-history-5-2022.11.06-000001"
    ],
    "data_streams" : [
      "ilm-history-5",
      ".logs-deprecation.elasticsearch-default"
    ],
    "include_global_state" : true,
    "state" : "SUCCESS",
    "start_time" : "2022-11-06T19:17:21.650Z",
    "start_time_in_millis" : 1667762241650,
    "end_time" : "2022-11-06T19:17:23.259Z",
    "end_time_in_millis" : 1667762243259,
    "duration_in_millis" : 1609,
    "failures" : [ ],
    "shards" : {
      "total" : 4,
      "failed" : 0,
      "successful" : 4
    },
    "feature_states" : [
      {
        "feature_name" : "geoip",
        "indices" : [
          ".geoip_databases"
        ]
      }
    ]
  }
}
```

**Приведите в ответе** список файлов в директории со `snapshot`ами.

```
[elasticsearch@31321bf0f304 snapshots]$ ls
index-0  index.latest  indices  meta-sublyLIQTA-YzLeP8W6InQ.dat  snap-sublyLIQTA-YzLeP8W6InQ.dat
```

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

```
[root@testdb docker]# curl -X DELETE "localhost:9200/test?pretty"
{
  "acknowledged" : true
}
[root@testdb docker]# curl -X PUT "localhost:9200/test-2?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  }
}
'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}
[root@testdb docker]# curl -X GET "localhost:9200/_cat/indices?v"
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases ojkVfGO-Qb6AT1Ew3GZ_Xg   1   0         40            0     38.4mb         38.4mb
green  open   test-2           Ew-uiarKQzCRrTD5m6olig   1   0          0            0       226b           226b
```

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 


**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

```
[root@testdb docker]# curl -X POST "localhost:9200/_snapshot/netology_backup/snapshot_1/_restore?pretty" -H 'Content-Type: application/json' -d'
{
  "indices": "test",
  "include_global_state": true
}
'
{
  "accepted" : true
}
[root@testdb docker]# curl -X GET "localhost:9200/_cat/indices?v"
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases KRRjYvM6RryLHQx-DVVM7w   1   0         40            0     38.4mb         38.4mb
green  open   test-2           Ew-uiarKQzCRrTD5m6olig   1   0          0            0       226b           226b
green  open   test             LYWoCVzYSeyIGaIEj9TvBA   1   0          0            0       226b           226b
```

---
