# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 2»

### Задание 1. Создать Deployment приложений backend и frontend

1. Создать Deployment приложения _frontend_ из образа nginx с количеством реплик 3 шт.
2. Создать Deployment приложения _backend_ из образа multitool. 
3. Добавить Service, которые обеспечат доступ к обоим приложениям внутри кластера. 
4. Продемонстрировать, что приложения видят друг друга с помощью Service.
5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.

### Ответ

[Создан манифест Deployment frontend](./deployment1.yaml)

[Создан манифест Deployment backend](./deployment2.yaml)

![Deployment запущены](./src/1.png "Deployment запущены")

[Создан манифест Service frontend](./service1.yaml)

[Создан манифест Service backend](./service2.yaml)

![Service запущены](./src/2.png "Service запущены")

![Доступ из frontend в backend](./src/3.png "Доступ из frontend в backend")

![Доступ из backend в frontend](./src/4.png "Доступ из backend в frontend")

### Задание 2. Создать Ingress и обеспечить доступ к приложениям снаружи кластера

1. Включить Ingress-controller в MicroK8S.
2. Создать Ingress, обеспечивающий доступ снаружи по IP-адресу кластера MicroK8S так, чтобы при запросе только по адресу открывался _frontend_ а при добавлении /api - _backend_.
3. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.
4. Предоставить манифесты и скриншоты или вывод команды п.2.

### Ответ

![Включен Ingress-controller](./src/5.png "Включен Ingress-controller")

[Создан манифест Ingress](./ingress.yaml)

![Ingress запущен](./src/6.png "Ingress запущен")

![Доступ к frontend](./src/7.png "Доступ к frontend")

![Доступ к backend](./src/8.png "Доступ к backend")