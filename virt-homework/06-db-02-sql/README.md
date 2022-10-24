# Домашнее задание к занятию "6.2. SQL"


## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

```
version: '3'

services:

  postgres:
    image: postgres:12
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

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

```
postgres@f5d61075ee4d:/$ createdb test_db
postgres@f5d61075ee4d:/$ psql test_db
test_db=# CREATE USER "test-admin-user" WITH PASSWORD 'admin';
test_db=# CREATE USER "test-simple-user" WITH PASSWORD 'simple';
test_db=# CREATE TABLE orders (
                    id serial primary key,
                    name varchar(80),
                    price int);

CREATE TABLE clients (
                    id serial primary key,
                    surname varchar(50),
                    country varchar(20), 
                    ordering int,
                    foreign key (ordering) references orders (id));
GRANT ALL PRIVILEGES ON  TABLE clients, orders  TO "test-admin-user";
GRANT SELECT, INSERT, UPDATE, DELETE ON  TABLE clients, orders  TO "test-simple-user";
```

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db
```
test_db=# \l
                                     List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |       Access privileges        
-----------+----------+----------+------------+------------+--------------------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                   +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                   +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/postgres                  +
           |          |          |            |            | postgres=CTc/postgres         +
           |          |          |            |            | "test-admin-user"=CTc/postgres
```
```
test_db=# \d orders
                                   Table "public.orders"
 Column |         Type          | Collation | Nullable |              Default               
--------+-----------------------+-----------+----------+------------------------------------
 id     | integer               |           | not null | nextval('orders_id_seq'::regclass)
 name   | character varying(80) |           |          | 
 price  | integer               |           |          | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_ordering_fkey" FOREIGN KEY (ordering) REFERENCES orders(id)


test_db=# \d clients
                                    Table "public.clients"
  Column  |         Type          | Collation | Nullable |               Default               
----------+-----------------------+-----------+----------+-------------------------------------
 id       | integer               |           | not null | nextval('clients_id_seq'::regclass)
 surname  | character varying(50) |           |          | 
 country  | character varying(20) |           |          | 
 ordering | integer               |           |          | 
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "clients_ordering_fkey" FOREIGN KEY (ordering) REFERENCES orders(id)
```
```
test_db=# select * from information_schema.table_privileges where grantee in ('test-admin-user', 'test-simple-user');

 grantor  |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy 
----------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 postgres | test-simple-user | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test-simple-user | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | DELETE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test-admin-user  | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | DELETE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | TRUNCATE       | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | REFERENCES     | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | TRIGGER        | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test-simple-user | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test-admin-user  | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | TRUNCATE       | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | REFERENCES     | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | TRIGGER        | NO           | NO
(22 rows)
```
## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

```
test_db=# INSERT INTO orders (name, price) VALUES
	('Шоколад', 10),
	('Принтер', 3000),
	('Книга', 500),
	('Монитор', 7000),
	('Гитара', 4000);
	
test_db=# INSERT INTO clients (surname, country) VALUES
	('Иванов Иван Иванович', 'USA'),
	('Петров Петр Петрович', 'Canada'),
	('Иоганн Себастьян Бах', 'Japan'),
	('Ронни Джеймс Дио', 'Russia'),
	('Ritchie Blackmore', 'Russia');

```

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

```
test_db=# select COUNT(*) from clients;
 count 
-------
     5
(1 row)

test_db=# select COUNT(*) from orders;
 count 
-------
     5
(1 row)
```
	
	

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказк - используйте директиву `UPDATE`.

```
test_db=# UPDATE clients SET ordering = (SELECT id FROM orders WHERE name='Книга') WHERE surname='Иванов Иван Иванович';
test_db=# UPDATE clients SET ordering = (SELECT id FROM orders WHERE name='Монитор') WHERE surname='Петров Петр Петрович';
test_db=# UPDATE clients SET ordering = (SELECT id FROM orders WHERE name='Гитара') WHERE surname='Иоганн Себастьян Бах';
```

```
test_db=# SELECT clients.surname "ФИО", orders.name "Заказ"  FROM clients INNER JOIN orders ON clients.ordering=orders.id;
         ФИО          |  Заказ  
----------------------+---------
 Иванов Иван Иванович | Книга
 Петров Петр Петрович | Монитор
 Иоганн Себастьян Бах | Гитара
(3 rows)
```

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.
```
test_db=# EXPLAIN SELECT clients.surname "ФИО", orders.name "Заказ"  FROM clients INNER JOIN orders ON clients.ordering=orders.id;
                              QUERY PLAN                               
-----------------------------------------------------------------------
 Hash Join  (cost=18.55..33.36 rows=380 width=296)
   Hash Cond: (clients.ordering = orders.id)
   ->  Seq Scan on clients  (cost=0.00..13.80 rows=380 width=122)
   ->  Hash  (cost=13.80..13.80 rows=380 width=182)
         ->  Seq Scan on orders  (cost=0.00..13.80 rows=380 width=182)
(5 rows)
```
EXPLAIN выводит план выполнения запроса. Для каждого узла плана выводится приблизительная стоимость запуска, приблизительная общая стоимость, ожидаемое число строк и ожидаемый средний размер строк.
Стоимость может измеряться в произвольных единицах, определяемых параметрами планировщика.

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

```
root@f5d61075ee4d:/# pg_dump -U postgres test_db -f  /var/lib/postgresql/backups/test_db.dump
```

```
[root@testdb ~]# docker run -d --name=postgres2 -e POSTGRES_PASSWORD=postgres -v /opt/postgresql/backups/:/var/lib/postgresql/backups postgres:12
d892ea3d28da4eded420aeca9ce00f641a304a1297595b393b0b5b89a1d5f1fd
[root@testdb ~]# docker exec -it postgres2 bash
root@d892ea3d28da:/# su postgres
postgres@d892ea3d28da:/$ createdb test_db
postgres@d892ea3d28da:/$ psql test_db < /var/lib/postgresql/backups/test_db.dump

```


---
