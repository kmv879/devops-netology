# Домашнее задание к занятию "10.Jenkins"

## Подготовка к выполнению

1. Создать 2 VM: для jenkins-master и jenkins-agent.

С помощью Terraform было создано 2 виртуальные машины

![Создание виртуальных машин](./src/terraform.png "Создание виртуальных машин")

2. Установить jenkins при помощи playbook'a.

![Установка jenkins](./src/install_jenkins.png "Установка jenkins")

3. Запустить и проверить работоспособность.
4. Сделать первоначальную настройку.

Был настроен агент

![Настройка агента](./src/agent.png "Настройка агента")

![Запущенный агент](./src/run_agent.png "Запущенный агент")

## Основная часть

1. Сделать Freestyle Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.

Freestyle Job запускает `molecule test` роли [vector-role](https://github.com/kmv879/vector-role)

![Freestyle job](./src/freestyle.png "Freestyle job")

![Freestyle job вывод консоли](./src/freestyle_con.png "Freestyle job вывод консоли")


2. Сделать Declarative Pipeline Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.

Declarative Pipeline  Job запускает `molecule test` роли [vector-role](https://github.com/kmv879/vector-role)

![Declarative Pipeline job](./src/declarative_set.png "Declarative Pipeline job")

![Declarative Pipeline job](./src/declarative.png "Declarative Pipeline job")

![Declarative Pipeline job вывод консоли](./src/declarative_con.png "Declarative Pipeline job вывод консоли")

3. Перенести Declarative Pipeline в репозиторий в файл `Jenkinsfile`.

[Jenkinsfile](./Jenkinsfile)

4. Создать Multibranch Pipeline на запуск `Jenkinsfile` из репозитория.

![Multibranch Pipeline](./src/multibranch1.png "Multibranch Pipeline")

![Multibranch Pipeline](./src/multibranch2.png "Multibranch Pipeline")

![Multibranch Pipeline вывод консоли](./src/multibranch_con.png "Multibranch Pipeline вывод консоли")


5. Создать Scripted Pipeline, наполнить его скриптом.
6. Внести необходимые изменения, чтобы Pipeline запускал `ansible-playbook` без флагов `--check --diff`, если не установлен параметр при запуске джобы (prod_run = True), по умолчанию параметр имеет значение False и запускает прогон с флагами `--check --diff`.

![Scripted Pipeline](./src/scripted.png "Scripted Pipeline")

Запуск при prod_run = True

![Scripted Pipeline](./src/scripted_true.png "Scripted Pipeline")

![Scripted Pipeline](./src/scripted_true_con.png "Scripted Pipeline")

Запуск при prod_run = False

![Scripted Pipeline](./src/scripted_false.png "Scripted Pipeline")

![Scripted Pipeline](./src/scripted_false_con.png "Scripted Pipeline")


7. Проверить работоспособность, исправить ошибки, исправленный Pipeline вложить в репозиторий в файл `ScriptedJenkinsfile`.

[ScriptedJenkinsfile](./ScriptedJenkinsfile)


---
