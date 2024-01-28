# Домашнее задание к занятию «Запуск приложений в K8S»

### Задание 1. Создать Deployment и обеспечить доступ к репликам приложения из другого Pod

1. Создать Deployment приложения, состоящего из двух контейнеров — nginx и multitool. Решить возникшую ошибку.
2. После запуска увеличить количество реплик работающего приложения до 2.
3. Продемонстрировать количество подов до и после масштабирования.
4. Создать Service, который обеспечит доступ до реплик приложений из п.1.
5. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложений из п.1.

### Ответ

[Создан манифест Deployment](./deployment1.yaml)

![Deployment запущен](./src/1.png "Deployment запущен")

Количество реплик увеличено до 2

![Deployment запущен](./src/2.png "Deployment запущен")

[Создан манифест Service](./service1.yaml)

![Service запущен](./src/3.png "Service запущен")

Создан отдельный Pod multitool

![Multitool запущен](./src/4.png "Multitool запущен")

Доступ из multitool в приложение

![Доступ из multitool](./src/5.png "Доступ из multitool")

### Задание 2. Создать Deployment и обеспечить старт основного контейнера при выполнении условий

1. Создать Deployment приложения nginx и обеспечить старт контейнера только после того, как будет запущен сервис этого приложения.
2. Убедиться, что nginx не стартует. В качестве Init-контейнера взять busybox.
3. Создать и запустить Service. Убедиться, что Init запустился.
4. Продемонстрировать состояние пода до и после запуска сервиса.

### Ответ

[Создан манифест Deployment](./deployment2.yaml)

![Deployment запущен](./src/6.png "Deployment запущен")

nginx не запускается и ожидает выполнения init-контейнера

![nginx not running](./src/7.png "nginx not running")

Логи init-контейнера

![init-container logs](./src/8.png "init-container logs")

[Создан манифест Service](./service2.yaml)

nginx запустился после запуска service

![nginx running](./src/9.png "nginx running")
