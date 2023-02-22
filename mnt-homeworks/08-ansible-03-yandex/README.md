# Домашнее задание к занятию "8.3 Использование Yandex Cloud"

## Описание:

Playbook производит настройку двух серверов:

1. Сервер `clickhouse-01` для сбора логов.
2. Сервер `vector-01`, для отправки логов на сервер `clickhouse-01`
3. Сервер `lighthouse-01` - GUI интерфейс для `clickhouse`

## Предварительный требования

Inventory для playbook формируется автоматически с помощью terraform после создания виртуальных машин в Yandex cloud.


## Playbook

Playbook состоит из трех сценариев:


- ### Install Clickhouse

  - устанавливает пакеты `clickhouse`
  - создает базу данных и таблицу для хранения логов


- ### Install Vector

  - устанавливает пакет `vector`
  - создает конфигурационный файл

- ### Install lighthouse

  - устанавливает пакеты `epel-release`, `git`
  - устанавливает `nginx`
  - клонирует репозиторий `lighthouse` в каталог `nginx`


## Параметры

Через group_vars можно задать следующие параметры:
- `clickhouse_version`, `vector_version` - версии устанавливаемых приложений;
- `clickhouse_packages` - устанавливаемые пакеты `clickhouse`;
- `clickhouse_database_name` - имя базы данных для хранения логов;
- `clickhouse_create_table` - структура таблицы для хранения логов;
- `vector_config` - содержимое конфигурационного  `vector`
