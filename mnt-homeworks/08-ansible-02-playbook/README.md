# Домашнее задание к занятию "8.2 Работа с Playbook"

## Описание:

Playbook производит настройку двух серверов:

1. Сервер `clickhouse-01` для сбора логов.
2. Сервер `vector-01`, для отправки логов на сервер `clickhouse-01`

## Playbook

Playbook состоит из двух сценариев:


- ### Install Clickhouse

  - устанавливает пакеты `clickhouse`
  - создает базу данных и таблицу для хранения логов


- ### Install Vector

  - устанавливает пакет `vector`
  - создает конфигурационный файл


## Параметры

Через group_vars можно задать следующие параметры:
- `clickhouse_version`, `vector_version` - версии устанавливаемых приложений;
- `clickhouse_packages` - устанавливаемые пакеты `clickhouse`;
- `clickhouse_database_name` - имя базы данных для хранения логов;
- `clickhouse_create_table` - структура таблицы для хранения логов;
- `vector_config` - содержимое конфигурационного  `vector`
