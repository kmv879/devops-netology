# Домашнее задание к занятию «Обновление приложений»

### Цель задания

Выбрать и настроить стратегию обновления приложения.


### Задание 1. Выбрать стратегию обновления приложения и описать ваш выбор

1. Имеется приложение, состоящее из нескольких реплик, которое требуется обновить.
2. Ресурсы, выделенные для приложения, ограничены, и нет возможности их увеличить.
3. Запас по ресурсам в менее загруженный момент времени составляет 20%.
4. Обновление мажорное, новые версии приложения не умеют работать со старыми.
5. Вам нужно объяснить свой выбор стратегии обновления приложения.


В данном случае можно выбрать стратегию обновления Rolling update с указанием параметров maxSurge maxUnavailable для избежания ситуации с нехваткой ресурсов. В случае ошибки обновления можно будет быстро откатиться к предыдущему состоянию.


### Задание 2. Обновить приложение

1. Создать deployment приложения с контейнерами nginx и multitool. Версию nginx взять 1.19. Количество реплик — 5.
2. Обновить версию nginx в приложении до версии 1.20, сократив время обновления до минимума. Приложение должно быть доступно.
3. Попытаться обновить nginx до версии 1.28, приложение должно оставаться доступным.
4. Откатиться после неудачного обновления.


Созданы deployment и сервис.

[Deployment](./deployment.yaml)

[Service](./service.yaml)

```
kmv@master:~$ kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
deployment-6f4f5964f8-kg752   2/2     Running   0          93s
deployment-6f4f5964f8-kz7gz   2/2     Running   0          93s
deployment-6f4f5964f8-lnkcp   2/2     Running   0          93s
deployment-6f4f5964f8-nwcvp   2/2     Running   0          93s
deployment-6f4f5964f8-qvgcc   2/2     Running   0          93s

kmv@master:~$ kubectl get services
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
demo         ClusterIP   10.152.183.117   <none>        9001/TCP,9002/TCP   96s
kubernetes   ClusterIP   10.152.183.1     <none>        443/TCP             24h
```

Для обновления меняется параметр image: nginx:1.19 на 1.20 в deployment.yaml.

```
kmv@master:~$ kubectl get pods
NAME                          READY   STATUS              RESTARTS   AGE
deployment-54fc9dd774-cxncz   0/2     ContainerCreating   0          6s
deployment-54fc9dd774-s28c6   0/2     ContainerCreating   0          6s
deployment-6f4f5964f8-kz7gz   2/2     Running             0          4m41s
deployment-6f4f5964f8-lnkcp   2/2     Running             0          4m41s
deployment-6f4f5964f8-nwcvp   2/2     Running             0          4m41s
deployment-6f4f5964f8-qvgcc   2/2     Running             0          4m41s
kmv@master:~$ kubectl get pods
NAME                          READY   STATUS              RESTARTS   AGE
deployment-54fc9dd774-cxncz   2/2     Running             0          18s
deployment-54fc9dd774-l42xk   0/2     ContainerCreating   0          7s
deployment-54fc9dd774-q4cbm   2/2     Running             0          7s
deployment-54fc9dd774-qdf8j   0/2     ContainerCreating   0          2s
deployment-54fc9dd774-s28c6   2/2     Running             0          18s
deployment-6f4f5964f8-lnkcp   2/2     Running             0          4m53s
deployment-6f4f5964f8-nwcvp   2/2     Terminating         0          4m53s
kmv@master:~$ kubectl get pods
NAME                          READY   STATUS 	RESTARTS   AGE
deployment-54fc9dd774-cxncz   2/2     Running   0          43s
deployment-54fc9dd774-l42xk   2/2     Running   0          32s
deployment-54fc9dd774-q4cbm   2/2     Running   0          32s
deployment-54fc9dd774-qdf8j   2/2     Running   0          27s
deployment-54fc9dd774-s28c6   2/2     Running   0          43s
```
```
kmv@master:~$ kubectl describe deployment deployment
Name:                   deployment
Namespace:              default
CreationTimestamp:      Wed, 27 Mar 2024 18:34:26 +0000
Labels:                 app=demo
Annotations:            deployment.kubernetes.io/revision: 2
Selector:               app=demo
Replicas:               5 desired | 5 updated | 5 total | 5 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  1 max unavailable, 1 max surge
Pod Template:
  Labels:  app=demo
  Containers:
   nginx:
    Image:        nginx:1.20
    Port:         80/TCP
    Host Port:    0/TCP
    Environment:  <none>
    Mounts:       <none>
   network-multitool:
    Image:       wbitt/network-multitool
    Ports:       8080/TCP, 11443/TCP
    Host Ports:  0/TCP, 0/TCP
    Limits:
      cpu:     10m
      memory:  20Mi
    Requests:
      cpu:     1m
      memory:  20Mi
    Environment:
      HTTP_PORT:   8080
      HTTPS_PORT:  11443
    Mounts:        <none>
  Volumes:         <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  deployment-6f4f5964f8 (0/0 replicas created)
NewReplicaSet:   deployment-54fc9dd774 (5/5 replicas created)
Events:
  Type    Reason             Age                  From                   Message
  ----    ------             ----                 ----                   -------
  Normal  ScalingReplicaSet  2m7s                 deployment-controller  Scaled up replica set deployment-54fc9dd774 to 1
  Normal  ScalingReplicaSet  2m7s                 deployment-controller  Scaled down replica set deployment-6f4f5964f8 to 4 from 5
  Normal  ScalingReplicaSet  2m7s                 deployment-controller  Scaled up replica set deployment-54fc9dd774 to 2 from 1
  Normal  ScalingReplicaSet  116s                 deployment-controller  Scaled down replica set deployment-6f4f5964f8 to 3 from 4
  Normal  ScalingReplicaSet  116s                 deployment-controller  Scaled up replica set deployment-54fc9dd774 to 3 from 2
  Normal  ScalingReplicaSet  116s                 deployment-controller  Scaled down replica set deployment-6f4f5964f8 to 2 from 3
  Normal  ScalingReplicaSet  116s                 deployment-controller  Scaled up replica set deployment-54fc9dd774 to 4 from 3
  Normal  ScalingReplicaSet  111s                 deployment-controller  Scaled down replica set deployment-6f4f5964f8 to 1 from 2
  Normal  ScalingReplicaSet  108s (x2 over 111s)  deployment-controller  (combined from similar events): Scaled down replica set deployment-6f4f5964f8 to 0 from 1

```

Попытка обновления до nginx 1.28

```
kmv@master:~$ kubectl get pods
NAME                          READY   STATUS             RESTARTS   AGE
deployment-54fc9dd774-cxncz   2/2     Running            0          4m24s
deployment-54fc9dd774-l42xk   2/2     Running            0          4m13s
deployment-54fc9dd774-q4cbm   2/2     Running            0          4m13s
deployment-54fc9dd774-qdf8j   2/2     Running            0          4m8s
deployment-6c46c86958-fqm5m   1/2     ImagePullBackOff   0          13s
deployment-6c46c86958-xhfwt   1/2     ImagePullBackOff   0          13s
```

Приложение доступно

```
kmv@master:~$ kubectl exec deployment/deployment -- curl demo:9001
Defaulted container "nginx" out of: nginx, network-multitool
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
100   612  100   612    0     0    714      0 --:--:-- --:--:-- --:--:--   714
```

Откат обновлений

```
kmv@master:~$ kubectl rollout undo deployment deployment
deployment.apps/deployment rolled back
kmv@master:~$ kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
deployment-54fc9dd774-cxncz   2/2     Running   0          8m55s
deployment-54fc9dd774-l42xk   2/2     Running   0          8m44s
deployment-54fc9dd774-q4cbm   2/2     Running   0          8m44s
deployment-54fc9dd774-qdf8j   2/2     Running   0          8m39s
deployment-54fc9dd774-t8cdt   2/2     Running   0          24s
```


## Дополнительные задания — со звёздочкой*

Задания дополнительные, необязательные к выполнению, они не повлияют на получение зачёта по домашнему заданию. **Но мы настоятельно рекомендуем вам выполнять все задания со звёздочкой.** Это поможет лучше разобраться в материале.   

### Задание 3*. Создать Canary deployment

1. Создать два deployment'а приложения nginx.
2. При помощи разных ConfigMap сделать две версии приложения — веб-страницы.
3. С помощью ingress создать канареечный деплоймент, чтобы можно было часть трафика перебросить на разные версии приложения.

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
