## Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера."

### Задача 1  
Сценарий выполения задачи:  

создайте свой репозиторий на https://hub.docker.com;  
выберете любой образ, который содержит веб-сервер Nginx;  
создайте свой fork образа;  
реализуйте функциональность: запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:  
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.    

Содержимое Dockerfile   
```
FROM nginx:1.22.0

COPY index.html /usr/share/nginx/html
```

Содержимое index.html
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```


[Ссылка на hub.docker.com](https://hub.docker.com/repository/docker/kmv879/nginx)


 


### Задача 2  
Посмотрите на сценарий ниже и ответьте на вопрос: "Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"  

Детально опишите и обоснуйте свой выбор.  

--  

Сценарий:  

Высоконагруженное монолитное java веб-приложение;  
Физическая машина для максимальной производительности  

Nodejs веб-приложение;  
Docker. Можно быстро развернуть приложение со всеми зависимостями.  

Мобильное приложение c версиями для Android и iOS;  
Скорее всего виртуальная машина в связи со сложностью установки необходимых библиотек.  

Шина данных на базе Apache Kafka;  
Docker. Существуют уже готовые образы.  

Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana; 
Docker. Можно развернуть кластер с помощью Docker Compose  

Мониторинг-стек на базе Prometheus и Grafana;  
Docker. Можно развернуть с помощью Docker Compose  

MongoDB, как основное хранилище данных для java-приложения; 
Виртуальная машина. Позволяет максимально использовать ресурсы, организовывать резервное копирование.

Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.  
Также виртуальная машина.  


### Задача 3  
Запустите первый контейнер из образа centos c любым тэгом в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера;  
Запустите второй контейнер из образа debian в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера;  
Подключитесь к первому контейнеру с помощью docker exec и создайте текстовый файл любого содержания в /data;  
Добавьте еще один файл в папку /data на хостовой машине;  
Подключитесь во второй контейнер и отобразите листинг и содержание файлов в /data контейнера.  

Запуск контейнеров
```
vagrant@vagrant:~/docker$ docker run -it -v  /home/vagrant/docker/data/:/data -d  centos
215612cdd9aced9d2a13823d5e1def73b43e7ba7a91908c4ab832ce1f8280bcb
vagrant@vagrant:~/docker$ docker run -it -v  /home/vagrant/docker/data/:/data -d  debian
d55aff7c3b83af0124ca3016ced1a709a7c59cfa6a287653a55d38b21c8c2dc7
vagrant@vagrant:~/docker$ docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED          STATUS          PORTS     NAMES
d55aff7c3b83   debian    "bash"        14 seconds ago   Up 13 seconds             quizzical_wilson
215612cdd9ac   centos    "/bin/bash"   20 seconds ago   Up 19 seconds             funny_varahamihira
```

Создание файла в первом контейнере
```
vagrant@vagrant:~/docker$ docker exec -it funny_varahamihira bash
[root@215612cdd9ac /]# cd /data/
[root@215612cdd9ac data]# echo "centos data" >> centos_data
```

Создание файла на хостовой машине
```
vagrant@vagrant:~/docker/data$ echo "host data" >> host_data
```

Подключение ко второму контейнеру
```
vagrant@vagrant:~/docker/data$ docker exec -it quizzical_wilson bash
root@d55aff7c3b83:/# cd data/
root@d55aff7c3b83:/data# ls
centos_data  host_data
root@d55aff7c3b83:/data# cat centos_data 
centos data
root@d55aff7c3b83:/data# cat host_data 
host data
root@d55aff7c3b83:/data# 
```



### Задача 4(*)   
Воспроизвести практическую часть лекции самостоятельно.  

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.  

[Ссылка на hub.docker.com](https://hub.docker.com/repository/docker/kmv879/ansible)