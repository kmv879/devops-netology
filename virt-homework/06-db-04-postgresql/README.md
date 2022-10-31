# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

```
version: '3'

services:

  postgres:
    image: postgres:13
    container_name: postgres
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
    ports:
      - '5432:5432'
    volumes:
      - /opt/postgresql/backups:/var/lib/postgresql/backups
      - /opt/postgresql/data:/var/lib/postgresql/data
    restart: always
```
```
[root@testdb ~]# docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED      STATUS      PORTS                                       NAMES
a90c3fe73cbd   postgres:13   "docker-entrypoint.s…"   3 days ago   Up 3 days   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgres
[root@testdb ~]# docker exec -it postgres bash
root@a90c3fe73cbd:/# psql --version
psql (PostgreSQL) 13.8 (Debian 13.8-1.pgdg110+1
```

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
```
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)
```
- подключения к БД
```
postgres=# \c postgres
You are now connected to database "postgres" as user "postgres".
```
- вывода списка таблиц
```
\dt[S+] [PATTERN]      list tables
```
- вывода описания содержимого таблиц
```
\d[S+]  NAME           describe table, view, sequence, or index
```
- выхода из psql
```
\q                     quit psql
```  

## Задача 2

Используя `psql` создайте БД `test_database`.

```
postgres=# CREATE DATABASE test_database;
CREATE DATABASE
```
Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

```
postgres@a90c3fe73cbd:/$ psql -d test_database < /var/lib/postgresql/backups/test_dump.sql 
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval 
--------
      8
(1 row)

ALTER TABLE
```

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

```
postgres@a90c3fe73cbd:/$ psql
psql (13.8 (Debian 13.8-1.pgdg110+1))
Type "help" for help.

postgres=# \c test_database
You are now connected to database "test_database" as user "postgres".
test_database=# ANALYZE;
ANALYZE

```

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.
```
test_database=# SELECT MAX(avg_width) FROM pg_stats WHERE tablename='orders';
 max 
-----
  16
(1 row)
```


## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.
```
test_database=# ALTER TABLE order RENAME TO orders_tmp;
test_database=# CREATE TABLE orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0);
test_database=# CREATE TABLE orders_1 (
    CHECK ( price > 499)
    ) INHERITS (orders);
test_database=# CREATE TABLE orders_2 (
    CHECK ( price <= 499)
    ) INHERITS (orders);
test_database=# CREATE RULE order_1_insert AS ON INSERT TO orders
     WHERE ( price > 499)
     DO INSTEAD INSERT INTO orders_1 VALUES (NEW.*);
test_database=# CREATE RULE order_2_insert AS ON INSERT TO orders
     WHERE ( price <= 499)
     DO INSTEAD INSERT INTO orders_2 VALUES (NEW.*)
test_database=# INSERT INTO orders SELECT * FROM orders_tmp;
```

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

Можно было создать таблицу orders, партицированную по цене и таблицы orders_1 и orders_2, как партиции таблицы order для price>499 и price<=499  соотвественно. 

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

```
postgres@a90c3fe73cbd:/$ pg_dump test_database > /var/lib/postgresql/backups/test_database.sql
```

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

Добавить в файле резервной копии к типу столбца 'title' UNIQUE. 
```
CREATE TABLE public.orders_tmp (
    id integer NOT NULL,
    title character varying(80) NOT NULL UNIQUE,
    price integer DEFAULT 0
);
```
Пример восстановления базы данных из резервной копии и добавления записи с уже существующим значением в поле title.

```
postgres@a90c3fe73cbd:/$ createdb newdb
postgres@a90c3fe73cbd:/$ psql -d newdb < /var/lib/postgresql/backups/test_database.sql
ostgres@a90c3fe73cbd:/$ psql 
psql (13.8 (Debian 13.8-1.pgdg110+1))
Type "help" for help.

postgres=# \c newdb 
You are now connected to database "newdb" as user "postgres".
newdb=# \d orders_tmp
                                 Table "public.orders_tmp"
 Column |         Type          | Collation | Nullable |              Default               
--------+-----------------------+-----------+----------+------------------------------------
 id     | integer               |           | not null | nextval('orders_id_seq'::regclass)
 title  | character varying(80) |           | not null | 
 price  | integer               |           |          | 0
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
    "orders_tmp_title_key" UNIQUE CONSTRAINT, btree (title)

newdb=# select * from orders_tmp
newdb-# ;
 id |        title         | price 
----+----------------------+-------
  1 | War and peace        |   100
  2 | My little database   |   500
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  6 | WAL never lies       |   900
  7 | Me and my bash-pet   |   499
  8 | Dbiezdmin            |   501
(8 rows)
newdb=# INSERT INTO orders_tmp (title, price) VALUES ('War and peace', 600);
ERROR:  duplicate key value violates unique constraint "orders_tmp_title_key"
DETAIL:  Key (title)=(War and peace) already exists.
```


---
