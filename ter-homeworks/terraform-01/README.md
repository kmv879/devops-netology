# Домашнее задание к занятию "Введение в Terraform"

### Цель задания

1. Установить и настроить Terrafrom.
2. Научиться использовать готовый код.

------

### Чеклист готовности к домашнему заданию

1. Скачайте и установите актуальную версию **terraform**(не менее 1.3.7). Приложите скриншот вывода команды ```terraform --version```
```
kmv@kmv-note:~/git/devops-netology/ter-homeworks/terraform-01/src$ terraform --version
Terraform v1.4.5
on linux_amd64
+ provider registry.terraform.io/hashicorp/random v3.5.1
+ provider registry.terraform.io/kreuzwerker/docker v3.0.2

```
2. Скачайте на свой ПК данный git репозиторий. Исходный код для выполнения задания расположен в директории **01/src**.
3. Убедитесь, что в вашей ОС установлен docker

------


### Задание 1

1. Перейдите в каталог [**src**](https://github.com/netology-code/ter-homeworks/tree/main/01/src). Скачайте все необходимые зависимости, использованные в проекте. 
2. Изучите файл **.gitignore**. В каком terraform файле допустимо сохранить личную, секретную информацию?

Личная и секретная информация должна храниться в файле personal.auto.tfvars

3. Выполните код проекта. Найдите  в State-файле секретное содержимое созданного ресурса **random_password**. Пришлите его в качестве ответа.

Созданный пароль "gf5D6teeZTlUGK6b"

```
kmv@kmv-note:~/git/devops-netology/ter-homeworks/terraform-01/src$ cat terraform.tfstate 
{
  "version": 4,
  "terraform_version": "1.4.5",
  "serial": 1,
  "lineage": "2b9fc9ea-92ee-3ba5-d252-b76aabb632bf",
  "outputs": {},
  "resources": [
    {
      "mode": "managed",
      "type": "random_password",
      "name": "random_string",
      "provider": "provider[\"registry.terraform.io/hashicorp/random\"]",
      "instances": [
        {
          "schema_version": 3,
          "attributes": {
            "bcrypt_hash": "$2a$10$Y27B3nT6Yy3oT7YnX9XEjOHlq5Irm2HwGZ1zVhXyZ6HGbHGXx5Y1W",
            "id": "none",
            "keepers": null,
            "length": 16,
            "lower": true,
            "min_lower": 1,
            "min_numeric": 1,
            "min_special": 0,
            "min_upper": 1,
            "number": true,
            "numeric": true,
            "override_special": null,
            "result": "gf5D6teeZTlUGK6b",
            "special": false,
            "upper": true
          },
          "sensitive_attributes": []
        }
      ]
    }
  ],
  "check_results": null
}

```

4. Раскомментируйте блок кода, примерно расположенный на строчках 29-42 файла **main.tf**.
Выполните команду ```terraform -validate```. Объясните в чем заключаются намеренно допущенные ошибки? Исправьте их.
```
kmv@kmv-note:~/git/devops-netology/ter-homeworks/terraform-01/src$ terraform validate
╷
│ Error: Missing name for resource
│ 
│   on main.tf line 24, in resource "docker_image":
│   24: resource "docker_image" {
│ 
│ All resource blocks must have 2 labels (type, name).
╵
╷
│ Error: Invalid resource name
│ 
│   on main.tf line 29, in resource "docker_container" "1nginx":
│   29: resource "docker_container" "1nginx" {
│ 
│ A name must start with a letter or underscore and may contain only letters, digits, underscores, and dashes.
╵
```
В первом случае пропущено имя ресурса, во втором случае название ресурса начинается с цифры.

```
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "example_${random_password.random_string.result}"

  ports {
    internal = 80
    external = 8000
  }

````

```
kmv@kmv-note:~/git/devops-netology/ter-homeworks/terraform-01/src$ terraform validate
Success! The configuration is valid.

```
5. Выполните код. В качестве ответа приложите вывод команды ```docker ps```

```
v@kmv-note:~/git/devops-netology/ter-homeworks/terraform-01/src$ sudo docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                  NAMES
715ce878464d   6efc10a0510f   "/docker-entrypoint.…"   14 seconds ago   Up 13 seconds   0.0.0.0:8000->80/tcp   example_gf5D6teeZTlUGK6b

```

6. Замените имя docker-контейнера в блоке кода на ```hello_world```, выполните команду ```terraform apply -auto-approve```.
Объясните своими словами, в чем может быть опасность применения ключа  ```-auto-approve``` ? 

Опасность ключа --auto-approve в том, что автоматически подтверждаются все изменения, даже если они содержат ошибочные значения.

8. Уничтожьте созданные ресурсы с помощью **terraform**. Убедитесь, что все ресурсы удалены. Приложите содержимое файла **terraform.tfstate**. 
```
kmv@kmv-note:~/git/devops-netology/ter-homeworks/terraform-01/src$ sudo terraform destroy
docker_image.nginx: Refreshing state... [id=sha256:feb5d9fea6a5e9606aa995e879d862b825965ba48de054caab5ef356dc6b3412hello-world]
random_password.random_string: Refreshing state... [id=none]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  - destroy

Terraform will perform the following actions:

  # docker_image.nginx will be destroyed
  - resource "docker_image" "nginx" {
      - id           = "sha256:feb5d9fea6a5e9606aa995e879d862b825965ba48de054caab5ef356dc6b3412hello-world" -> null
      - image_id     = "sha256:feb5d9fea6a5e9606aa995e879d862b825965ba48de054caab5ef356dc6b3412" -> null
      - keep_locally = true -> null
      - name         = "hello-world" -> null
      - repo_digest  = "hello-world@sha256:4e83453afed1b4fa1a3500525091dbfca6ce1e66903fd4c01ff015dbcb1ba33e" -> null
    }

  # random_password.random_string will be destroyed
  - resource "random_password" "random_string" {
      - bcrypt_hash = (sensitive value) -> null
      - id          = "none" -> null
      - length      = 16 -> null
      - lower       = true -> null
      - min_lower   = 1 -> null
      - min_numeric = 1 -> null
      - min_special = 0 -> null
      - min_upper   = 1 -> null
      - number      = true -> null
      - numeric     = true -> null
      - result      = (sensitive value) -> null
      - special     = false -> null
      - upper       = true -> null
    }

Plan: 0 to add, 0 to change, 2 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

docker_image.nginx: Destroying... [id=sha256:feb5d9fea6a5e9606aa995e879d862b825965ba48de054caab5ef356dc6b3412hello-world]
docker_image.nginx: Destruction complete after 0s
random_password.random_string: Destroying... [id=none]
random_password.random_string: Destruction complete after 0s

Destroy complete! Resources: 2 destroyed.
```

```
kmv@kmv-note:~/git/devops-netology/ter-homeworks/terraform-01/src$ cat terraform.tfstate
{
  "version": 4,
  "terraform_version": "1.4.5",
  "serial": 16,
  "lineage": "2b9fc9ea-92ee-3ba5-d252-b76aabb632bf",
  "outputs": {},
  "resources": [],
  "check_results": null
}
```

9. Объясните, почему при этом не был удален docker образ **nginx:latest** ?(Ответ найдите в коде проекта или документации)

Образ не был удален, потому что в ресурсе ```resource "docker_image" "nginx"``` для параметра keep_locally задано значение true. В данном случае скачанные образы Docker не удаляются после выполнения команды terraform destroy

------


