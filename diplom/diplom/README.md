# Дипломный практикум в Yandex.Cloud
  * [Цели:](#цели)
  * [Этапы выполнения:](#этапы-выполнения)
     * [Создание облачной инфраструктуры](#создание-облачной-инфраструктуры)
     * [Создание Kubernetes кластера](#создание-kubernetes-кластера)
     * [Создание тестового приложения](#создание-тестового-приложения)
     * [Подготовка cистемы мониторинга и деплой приложения](#подготовка-cистемы-мониторинга-и-деплой-приложения)
     * [Установка и настройка CI/CD](#установка-и-настройка-cicd)
  * [Что необходимо для сдачи задания?](#что-необходимо-для-сдачи-задания)
  * [Как правильно задавать вопросы дипломному руководителю?](#как-правильно-задавать-вопросы-дипломному-руководителю)

**Перед началом работы над дипломным заданием изучите [Инструкция по экономии облачных ресурсов](https://github.com/netology-code/devops-materials/blob/master/cloudwork.MD).**

---
## Цели:

1. Подготовить облачную инфраструктуру на базе облачного провайдера Яндекс.Облако.
2. Запустить и сконфигурировать Kubernetes кластер.
3. Установить и настроить систему мониторинга.
4. Настроить и автоматизировать сборку тестового приложения с использованием Docker-контейнеров.
5. Настроить CI для автоматической сборки и тестирования.
6. Настроить CD для автоматического развёртывания приложения.

---
## Этапы выполнения:


## Создание облачной инфраструктуры

   1. Создан сервисный аккаунт и подготовлен бакет для хранения стейт файлов terraform. [конфигурация](./terraform/bucket/bucket.tf).
   
   ![Bucket](./src/1.png "Bucket")
   
   2. Создание VPC с подсетями в разных зонах доступности [конфигурация](./terraform/networks.tf)
   
   ![Subnets](./src/2.png "Subnets")
   
   3. Результат создания облачной инфраструктуры три воркер ноды и одна мастер нода
   
   ![Instances](./src/3.png "Instances")

   4. Содержимое файла hosts.yml для создание kubernetes кластера посредством kubespray.

```
---
all:
  hosts:
    control-plane:
      ansible_host: 51.250.6.0
      ansible_user: ubuntu
    node-1:
      ansible_host: 62.84.113.73
      ansible_user: ubuntu
    node-2:
      ansible_host: 51.250.109.238
      ansible_user: ubuntu
    node-3:
      ansible_host: 158.160.167.81
      ansible_user: ubuntu
  children:
    kube_control_plane:
      hosts:
        control-plane:
    kube_node:
      hosts:
        node-1:
        node-2:
        node-3:
    etcd:
      hosts:
        control-plane:
    k8s_cluster:
      vars:
        supplementary_addresses_in_ssl_keys: [51.250.6.0]
      children:
        kube_control_plane:
        kube_node:
    calico_rr:
      hosts: {}

```



---

## Создание Kubernetes кластера

   1. Подготавливаем Kubespray.
```
$ git clone https://github.com/kubernetes-sigs/kubespray
$ sudo pip3 install -r requirements.txt
```
   2. Запускаем плейбук на основе inventory [hosts.yml](./kubespray/inventory/my-k8s-cluster/hosts.yml).
```
$ ansible-playbook -i inventory/my-k8s-cluster/hosts.yml --become --become-user=root cluster.yml
```   
   3. Проверяем доступность кластера.
   
   ![Кластер](./src/4.png "Кластер")



---
## Создание тестового приложения<

Докер-образ создан  основе nginx. [Репозиторий](https://github.com/kmv879/app).

   1.  [Dockerfile](https://github.com/kmv879/app/blob/main/Dockerfile)
   2.  [Конфиг nginx](https://github.com/kmv879/app/blob/main/nginx/app.conf)
   3.  [DockerHub](https://hub.docker.com/repository/docker/kmv879/my-app/general) 
   
   
   ![Dockerhub](./src/5.png)
   
   
   4. Для развертывания приложения в кластере созданы файлы deployment.yml, service.yml.

```
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
        - name: my-app
          image: kmv879/my-app:{{image_tag}}
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
```

```
---
apiVersion: v1
kind: Service
metadata:
  name: my-app-svc
spec:
  type: NodePort
  selector:
    app: my-app
  ports:
    - name: web
      nodePort: 30903
      port: 80
      targetPort: 80
```



---
## Подготовка cистемы мониторинга и разворачивание приложения

   1. Для разворачивания мониторинга воспользуемся helm [чартом](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)

```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus-stack  prometheus-community/kube-prometheus-stack
```
   2. Проверим поднятие мониторинга


![Мониторинг](./src/6.png)


   3. Создадим манифест сервиса NodePort для Grafana

```
---
apiVersion: v1
kind: Service
metadata:
  name: grafana
spec:
  type: NodePort
  selector:
    app.kubernetes.io/name: grafana
  ports:
    - name: http
      nodePort: 30902
      port: 3000
      targetPort: 3000
```

   4. Для доступа через внешний адрес  добавим конфигурацию терраформа с балансировщиком для приложения и графаны.
      
   [конфигурация](./terraform/nlb.tf)

   5. Проверим доступность

![Grafana](./src/7.png)

![Приложение](./src/8.png)


---
## Установка и настройка CI/CD

   Для создания пайплайна для сборки и разворачивания приложения выбран GitHub Actions.

   [Репозиторий](https://github.com/kmv879/app.git)

   1. [Ссылка манифест ci/cd](https://github.com/kmv879/app/blob/main/.github/workflows/main.yml) 
   
   2. Секреты и переменные создаются в веб интерфейсе github
   
![Секреты](./src/9.png)

   3. В процессе сборки образ создаётся на основе [Dockerfile](https://github.com/kmv879/app/blob/main/Dockerfile)
   


   4. При коммите без тега собирается только образ.
   
   ![Commit](./src/10.png)
   
   ![Job](./src/11.png)

   4. При коммите с тегом также разворачивается новая версия приложения.
   
   ![Commit](./src/12.png)
   
   ![Job](./src/13.png)

---
## Материалы необходимые для сдачи задания

1. [Репозиторий с конфигурационными файлами Terraform](https://github.com/kmv879/devops-netology/tree/main/diplom/diplom/terraform).
2. [Репозиторий с Dockerfile тестового приложения](https://github.com/kmv879/app) и [ссылка на собранный docker image](https://hub.docker.com/repository/docker/kmv879/my-app/general).
3. [Ссылка на тестовое приложение](http://158.160.175.97/) и [веб интерфейс Grafana](http://158.160.175.154:3000) с данными доступа:
   - login admin
   - pass prom-operator


