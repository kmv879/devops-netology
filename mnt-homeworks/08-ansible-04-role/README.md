# Домашнее задание к занятию "8.4 Работа с roles"

## Описание:

Playbook производит настройку трех серверов:

1. Сервер `clickhouse-01` для сбора логов.
2. Сервер `vector-01`, для отправки логов на сервер `clickhouse-01`
3. Сервер `lighthouse-01` - GUI интерфейс для `clickhouse`

## Предварительные требования

Inventory для playbook формируется автоматически с помощью terraform после создания виртуальных машин в Yandex cloud.


## Playbook

Playbook состоит из трех сценариев:


- ### Install Clickhouse

  - устанавливает пакеты `clickhouse`
  - создает базу данных и таблицу для хранения логов
  - используется роль AlexeySetevoi.ansible-clickhouse


- ### Install Vector

  - устанавливает пакет `vector`
  - создает конфигурационный файл
  - используется роль kmv879.vector-role

- ### Install lighthouse

  - устанавливает `lighthouse`
  - используется роль kmv879.lighthouse-role


