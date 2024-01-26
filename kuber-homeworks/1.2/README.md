# Домашнее задание к занятию «Базовые объекты K8S»

### Задание 1. Создать Pod с именем hello-world

1. Создать манифест (yaml-конфигурацию) Pod.
2. Использовать image - gcr.io/kubernetes-e2e-test-images/echoserver:2.2.
3. Подключиться локально к Pod с помощью `kubectl port-forward` и вывести значение (curl или в браузере).

### Ответ

[Создан манифест Pod](./hello-world.yaml)

![Pod запущен](./src/1.png "Pod запущен")

![Port-forward](./src/2.png "Port-forward")

![Обращение к Pod](./src/3.png "Обращение к Pod")

### Задание 2. Создать Service и подключить его к Pod

1. Создать Pod с именем netology-web.
2. Использовать image — gcr.io/kubernetes-e2e-test-images/echoserver:2.2.
3. Создать Service с именем netology-svc и подключить к netology-web.
4. Подключиться локально к Service с помощью `kubectl port-forward` и вывести значение (curl или в браузере).

### Ответ

[Создан манифест Pod](./netology-web.yaml)

![Pod запущен](./src/4.png "Pod запущен")

[Создан манифест Service](./netology-svc.yaml)

![Service запущен](./src/5.png "Service запущен")

![Port-forward](./src/6.png "Port-forward")

![Обращение к Service](./src/7.png "Обращение к Service")
