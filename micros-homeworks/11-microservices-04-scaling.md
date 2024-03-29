
# Домашнее задание к занятию «Микросервисы: масштабирование»

Вы работаете в крупной компании, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps-специалисту необходимо выдвинуть предложение по организации инфраструктуры для разработки и эксплуатации.

## Задача 1: Кластеризация

Предложите решение для обеспечения развёртывания, запуска и управления приложениями.
Решение может состоять из одного или нескольких программных продуктов и должно описывать способы и принципы их взаимодействия.

Решение должно соответствовать следующим требованиям:
- поддержка контейнеров;
- обеспечивать обнаружение сервисов и маршрутизацию запросов;
- обеспечивать возможность горизонтального масштабирования;
- обеспечивать возможность автоматического масштабирования;
- обеспечивать явное разделение ресурсов, доступных извне и внутри системы;
- обеспечивать возможность конфигурировать приложения с помощью переменных среды, в том числе с возможностью безопасного хранения чувствительных данных таких как пароли, ключи доступа, ключи шифрования и т. п.

## Ответ

Решением отвечающим всем указанным требованиям является Kubernetes.

- Kubernetes поддерживает контейнеры.
- Kubernetes DNS. Каждому сервису, созданному с помощью объекта service присваивается доменное имя совпадающее с именем самого сервиса. Маршрутизация происходит через kube-proxy и virtual ip.
- Горизонтальное автомасштабирование подов (Horizontal Pod Autoscaler, HPA), которое автоматически масштабирует количество подов в развертывании или наборе реплик.
- Автомасштабирование кластера (Cluster Autoscaler), которое отвечает за масштабирование узлов.
- Namespaces - это способ разделить кластер на индивидуальные зоны. NetworkPolicy и GlobalNetworkPolicy дает разграничение доступа внутри кластера, контроль исходящего и входящего трафика. ingress-controller - обеспечивает маршрутизацию трафика.
- В Kubernetes есть объект secret для хранения чувствительных данных. Также есть возможность использования Hashicorp vault. Env для установки переменных сред в контейнеры.

---
