# Домашнее задание к занятию "6.3. MySQL"


## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

В следующих заданиях мы будем продолжать работу с данным контейнером.

```
version: '3'

services:

  mysql:
    image: mysql:8.0
    container_name: mysql
    environment:
      MYSQL_ROOT_PASSWORD: mysql
      MYSQL_DATABASE: test_db
    ports:
      - '3306:3306'
    volumes:
      - /opt/mysql/data:/var/lib/mysql
    restart: always
```
```
bash-4.4# mysql -u root -p test_db < /var/lib/mysql/test_dump.sql
bash-4.4# mysql -u root -p
mysql> \s
--------------
mysql  Ver 8.0.31 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:		10
Current database:	
Current user:		root@localhost
SSL:			Not in use
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server version:		8.0.31 MySQL Community Server - GPL
Protocol version:	10
Connection:		Localhost via UNIX socket
Server characterset:	utf8mb4
Db     characterset:	utf8mb4
Client characterset:	latin1
Conn.  characterset:	latin1
UNIX socket:		/var/run/mysqld/mysqld.sock
Binary data as:		Hexadecimal
Uptime:			2 min 21 sec

Threads: 2  Questions: 35  Slow queries: 0  Opens: 138  Flush tables: 3  Open tables: 56  Queries per second avg: 0.248
--------------
```
```
mysql> USE test_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> SHOW TABLES;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.01 sec)
mysql> SELECT COUNT(*) FROM orders WHERE price>300;
+----------+
| COUNT(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)
```

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

```
mysql> CREATE USER 'test'@'localhost' IDENTIFIED WITH mysql_native_password
    -> BY 'test-pass'
    -> WITH MAX_QUERIES_PER_HOUR 100
    -> PASSWORD EXPIRE INTERVAL 180 DAY
    -> FAILED_LOGIN_ATTEMPTS 3
    -> ATTRIBUTE '{"Firstname": "James", "Lastname": "Pretty"}';
Query OK, 0 rows affected (0.02 sec)
```
Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.

```
mysql> GRANT SELECT ON test_db.* TO 'test'@'localhost';
Query OK, 0 rows affected, 1 warning (0.02 sec)
mysql> SHOW GRANTS FOR 'test'@'localhost';
+---------------------------------------------------+
| Grants for test@localhost                         |
+---------------------------------------------------+
| GRANT USAGE ON *.* TO `test`@`localhost`          |
| GRANT SELECT ON `test_db`.* TO `test`@`localhost` |
+---------------------------------------------------+
2 rows in set (0.00 sec)


```
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.
```
mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER='test';
+------+-----------+----------------------------------------------+
| USER | HOST      | ATTRIBUTE                                    |
+------+-----------+----------------------------------------------+
| test | localhost | {"Lastname": "Pretty", "Firstname": "James"} |
+------+-----------+----------------------------------------------+
1 row in set (0.01 sec)
```

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.
```
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> SHOW PROFILES;
Empty set, 1 warning (0.00 sec)
```


Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.
```
mysql> SHOW TABLE STATUS\G
*************************** 1. row ***************************
           Name: orders
         Engine: InnoDB
        Version: 10
     Row_format: Dynamic
           Rows: 5
 Avg_row_length: 3276
    Data_length: 16384
Max_data_length: 0
   Index_length: 0
      Data_free: 0
 Auto_increment: 6
    Create_time: 2022-10-24 11:57:19
    Update_time: 2022-10-24 11:57:19
     Check_time: NULL
      Collation: utf8mb4_0900_ai_ci
       Checksum: NULL
 Create_options: 
        Comment: 
1 row in set (0.02 sec)
```

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

```
mysql> ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.08 sec)
Records: 5  Duplicates: 0  Warnings: 0
mysql> ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.08 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SHOW PROFILES;
+----------+------------+------------------------------------+
| Query_ID | Duration   | Query                              |
+----------+------------+------------------------------------+
|        1 | 0.00064600 | SHOW ENGINES                       |
|        2 | 0.01826700 | SHOW TABLE STATUS                  |
|        3 | 0.07925875 | ALTER TABLE orders ENGINE = MyISAM |
|        4 | 0.00317175 | SHOW TABLE STATUS                  |
|        5 | 0.08338400 | ALTER TABLE orders ENGINE = InnoDB |
+----------+------------+------------------------------------+
5 rows in set, 1 warning (0.00 sec)
```

## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.
```
# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/8.0/en/server-configuration-defaults.html

[mysqld]
innodb_flush_method = O_DSYNC
innodb_flush_log_at_trx_commit = 2
innodb_file_per_table = ON

#
# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.

innodb_buffer_pool_size = 300M
innodb_log_file_size = 100M

#
# Remove leading # to turn on a very important data integrity option: logging
# changes to the binary log between backups.
# log_bin
#
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M

# Remove leading # to revert to previous value for default_authentication_plugin,
# this will increase compatibility with older clients. For background, see:
# https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_default_authentication_plugin
# default-authentication-plugin=mysql_native_password
skip-host-cache
skip-name-resolve
datadir=/var/lib/mysql
socket=/var/run/mysqld/mysqld.sock
secure-file-priv=/var/lib/mysql-files
user=mysql

pid-file=/var/run/mysqld/mysqld.pid
[client]
socket=/var/run/mysqld/mysqld.sock

!includedir /etc/mysql/conf.d/

```
---


