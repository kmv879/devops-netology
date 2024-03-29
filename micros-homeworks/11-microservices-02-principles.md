
# Домашнее задание к занятию «Микросервисы: принципы»

Вы работаете в крупной компании, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps-специалисту необходимо выдвинуть предложение по организации инфраструктуры для разработки и эксплуатации.

## Задача 1: API Gateway 

Предложите решение для обеспечения реализации API Gateway. Составьте сравнительную таблицу возможностей различных программных решений. На основе таблицы сделайте выбор решения.

Решение должно соответствовать следующим требованиям:
- маршрутизация запросов к нужному сервису на основе конфигурации,
- возможность проверки аутентификационной информации в запросах,
- обеспечение терминации HTTPS.

## Ответ

| Решение            | Маршрутизация | Аутентификация | Терминация HTTPS |
|--------------------|---------------|----------------|------------------|
| Tyk.io             | +             | +              | +                |
| HAProxy            | +             | +              | +                | 
| NGINX              | +             | +              | +                | 

Наиболее оптимальным решением будет NGINX, так как это бесплатный популярный продукт, который соответствует всем требованиям проекта. 


## Задача 2: Брокер сообщений

Составьте таблицу возможностей различных брокеров сообщений. На основе таблицы сделайте обоснованный выбор решения.

Решение должно соответствовать следующим требованиям:
- поддержка кластеризации для обеспечения надёжности,
- хранение сообщений на диске в процессе доставки,
- высокая скорость работы,
- поддержка различных форматов сообщений,
- разделение прав доступа к различным потокам сообщений,
- простота эксплуатации.

## Ответ

| Требование                                            | Kafka | RabbitMQ | ActiveMQ |
|-------------------------------------------------------|-------|----------|----------|
| Поддержка кластеризации для обеспечения надежности    | +     | +        | +        |
| Хранение сообщений на диске в процессе доставки       | +     | +        | +        |
| Высокая скорость работы                               | +     | -        | -        |
| Поддержка различных форматов сообщений                | +     | +        | +        |
| Разделение прав доступа к различным потокам сообщений | +     | +        | +        |
| Простота эксплуатации                                 | +     | +        | +        |

Наиболее оптимальным решением с максимальной прооизводттельностью будет Kafka


---
