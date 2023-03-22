# Домашнее задание к занятию "Основы Terraform. Yandex Cloud"

### Цель задания

1. Создать свои ресурсы в облаке Yandex Cloud с помощью Terraform.
2. Освоить работу с переменными Terraform.


### Чеклист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex Cli.
3. Исходный код для выполнения задания расположен в директории [**02/src**](https://github.com/netology-code/ter-homeworks/tree/main/02/src).


### Задание 0

1. Ознакомьтесь с [документацией к security-groups в Yandex Cloud](https://cloud.yandex.ru/docs/vpc/concepts/security-groups?from=int-console-help-center-or-nav).
2. Запросите preview доступ к данному функционалу в ЛК Yandex Cloud. Обычно его выдают в течении 24-х часов.
https://console.cloud.yandex.ru/folders/<ваш cloud_id>/vpc/security-groups
Этот функционал понадобится к следующей лекции. 


### Задание 1

1. Изучите проект. В файле variables.tf объявлены переменные для yandex provider.
2. Переименуйте файл personal.auto.tfvars_example в personal.auto.tfvars. Заполните переменные (идентификаторы облака, токен доступа). Благодаря .gitignore этот файл не попадет в публичный репозиторий. **Вы можете выбрать иной способ безопасно передать секретные данные в terraform.**
3. Сгенерируйте или используйте свой текущий ssh ключ. Запишите его открытую часть в переменную **vms_ssh_root_key**.
4. Инициализируйте проект, выполните код. Исправьте возникшую ошибку. Ответьте в чем заключается ее суть?

Инициализация проекта

```
kmv@kmv-note:~/git/devops-netology/ter-homeworks/terraform-02/src$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of yandex-cloud/yandex...
- Installing yandex-cloud/yandex v0.87.0...
- Installed yandex-cloud/yandex v0.87.0 (self-signed, key ID E40F590B50BB8E40)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

Ошибка
```
 Error: Error while requesting API to create instance: server-request-id = 9541af83-ac29-47ad-9eb8-63a234b6736a server-trace-id = bdf19da0904d3d6b:d9c25fdb253c78fe:bdf19da0904d3d6b:1 client-request-id = 5ddc497d-4011-45aa-919a-0ce8bb1d9c37 client-trace-id = 1b0c5cc5-de62-49a9-8a64-c8635d8ba4b4 rpc error: code = InvalidArgument desc = the specified number of cores is not available on platform "standard-v1"; allowed core number: 2, 4
│ 
│   with yandex_compute_instance.platform,
│   on main.tf line 15, in resource "yandex_compute_instance" "platform":
│   15: resource "yandex_compute_instance" "platform" {
│ 
```

Данная ошибка означает, что для платформы Intel Broadwell (standard-v1) при уровне производительности vCPU 5% доступно 2 или 4 вычислительных ядра, а в конфигурации задано 1.

5. Ответьте, что означает ```preemptible = true``` и ```core_fraction``` в параметрах ВМ? Как это может пригодится в процессе обучения? Ответ в документации Yandex cloud.

preemptible = true означает прерываемую виртуальную машину. 

Прерываемые виртуальные машины — это виртуальные машины, которые могут быть принудительно остановлены в любой момент. Это может произойти в двух случаях:
Если с момента запуска виртуальной машины прошло 24 часа.
Если возникнет нехватка ресурсов для запуска обычной виртуальной машины в той же зоне доступности. Вероятность такого события низкая, но может меняться изо дня в день.
Прерываемые виртуальные машины доступны по более низкой цене в сравнении с обычными, однако не обеспечивают отказоустойчивости.

core_fraction - уровень производительности vCPU. Этот уровень определяет долю вычислительного времени физических ядер, которую гарантирует vCPU.

Скриншот запущенной ВМ

![Запущенная ВМ](/ter-homeworks/terraform-02/img/1.png "Запущенная ВМ")

Скриншот подключения к консоли ВМ
 
 ![Консоль SSH](/ter-homeworks/terraform-02/img/2.png "Консоль SSH")

В качестве решения приложите:
- скриншот ЛК Yandex Cloud с созданной ВМ,
- скриншот успешного подключения к консоли ВМ через ssh,
- ответы на вопросы.


### Задание 2

1. Изучите файлы проекта.
2. Замените все "хардкод" **значения** для ресурсов **yandex_compute_image** и **yandex_compute_instance** на **отдельные** переменные. К названиям переменных ВМ добавьте в начало префикс **vm_web_** .  Пример: **vm_web_name**.
2. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их **default** прежними значениями из main.tf. 
3. Проверьте terraform plan (изменений быть не должно). 

 yandex_compute_image и yandex_compute_instance с переменными
 
 ```
 data "yandex_compute_image" "ubuntu" {
  family = var.wm_web_image_name
}
resource "yandex_compute_instance" "platform" {
  name        = var.wm_web_platform_name
  platform_id = var.wm_web_platform_id
  resources {
    cores         = var.wm_web_instance_cores
    memory        = var.wm_web_instance_memory
    core_fraction = var.wm_web_core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}
 ```

Файл variables.tf

```
###yandex_compute vars

variable "wm_web_image_name" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "image name"
}

variable "wm_web_platform_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "platform name"
}

variable "wm_web_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "platform id"
}

variable "wm_web_instance_cores" {
  type        = number
  default     = 2
  description = "instance vCPU cores"
}

variable "wm_web_instance_memory" {
  type        = number
  default     = 1
  description = "instance memory"
}

variable "wm_web_core_fraction" {
  type        = number
  default     = 5
  description = "instance core fraction"
}
````

### Задание 3

1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные ВМ.
2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ: **"netology-develop-platform-db"** ,  cores  = 2, memory = 2, core_fraction = 20. Объявите ее переменные с префиксом **vm_db_** в том же файле.
3. Примените изменения.

Часть файла main.tf

```
resource "yandex_compute_instance" "platform_db" {
  name        = var.wm_db_platform_name
  platform_id = var.wm_db_platform_id
  resources {
    cores         = var.wm_db_instance_cores
    memory        = var.wm_db_instance_memory
    core_fraction = var.wm_db_core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}

resource "yandex_compute_instance" "platform_web" {
  name        = var.wm_web_platform_name
  platform_id = var.wm_web_platform_id
  resources {
    cores         = var.wm_web_instance_cores
    memory        = var.wm_web_instance_memory
    core_fraction = var.wm_web_core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}
```

Файл vms_platform.tf

```
###yandex_compute vars

variable "wm_web_image_name" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "image name"
}

variable "wm_web_platform_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "platform name"
}

variable "wm_web_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "platform id"
}

variable "wm_web_instance_cores" {
  type        = number
  default     = 2
  description = "instance vCPU cores"
}

variable "wm_web_instance_memory" {
  type        = number
  default     = 1
  description = "instance memory"
}

variable "wm_web_core_fraction" {
  type        = number
  default     = 5
  description = "instance core fraction"
}

variable "wm_db_platform_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "platform name"
}

variable "wm_db_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "platform id"
}

variable "wm_db_instance_cores" {
  type        = number
  default     = 2
  description = "instance vCPU cores"
}

variable "wm_db_instance_memory" {
  type        = number
  default     = 2
  description = "instance memory"
}

variable "wm_db_core_fraction" {
  type        = number
  default     = 20
  description = "instance core fraction"
}
```

Скриншот запущенных ВМ

![Запущенные ВМ](/ter-homeworks/terraform-02/img/3.png "Запущенные ВМ")



### Задание 4

1. Объявите в файле outputs.tf отдельные output, для каждой из ВМ с ее внешним IP адресом.
2. Примените изменения.

В качестве решения приложите вывод значений ip-адресов команды ```terraform output```

Файл outputs.tf

```
output "external_ip_address_platform_db" {
  value = "${yandex_compute_instance.platform_db.network_interface.0.nat_ip_address}"
}

output "external_ip_address_platform_web" {
  value = "${yandex_compute_instance.platform_web.network_interface.0.nat_ip_address}"
}
```

```
kmv@kmv-note:~/git/devops-netology/ter-homeworks/terraform-02/src$ terraform output
external_ip_address_platform_db = "51.250.88.201"
external_ip_address_platform_web = "51.250.74.3"

```


### Задание 5

1. В файле locals.tf опишите в **одном** local-блоке имя каждой ВМ, используйте интерполяцию по примеру из лекции.
2. Замените переменные с именами ВМ из файла variables.tf на созданные вами local переменные.
3. Примените изменения.

Файл locals.tf

```
locals {
   vm_name = "netology-develop-platform"
}
```
Использование в main.tf

```
name        = "${ local.vm_name }-db"
```

### Задание 6

1. Вместо использования 3-х переменных  ".._cores",".._memory",".._core_fraction" в блоке  resources {...}, объедените их в переменные типа **map** с именами "vm_web_resources" и "vm_db_resources".
2. Так же поступите с блоком **metadata {serial-port-enable, ssh-keys}**, эта переменная должна быть общая для всех ваших ВМ.
3. Найдите и удалите все более не используемые переменные проекта.
4. Проверьте terraform plan (изменений быть не должно).

```
variable "vm_ssh" {
  type = map
  default = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8ZlCrxqfOR72bWaqI57RYWL7PNQOBqSs+qNoEZKddviWoozta0K1v1+usSNeqFMKMhF9OAGreE/7cdZRj0XArrYl6qXVmpJEfeiKCRLRi3XrHBmhF7FXnVpm45DR6YJ3mI6VpRg4ddmBs+oSr0mme431vgYluW6pRFBhdRZBAIn7Ip/zhQD2JQdkuqq4jrjbCY1QDl/UEwPlk7YOwqqDis6a710Xam9mBC+Owv6Tot2K1xwG4eq6+FsxLlp7eOeIsp72s44fPyGWeEaZikJz1hxyiaDg5Bv7Rrp3Ppy0rnKUmYE556umAaQ/HQsLVNPpPhV/qklpPZZMtY06yPBFu8rI7aVRNtGFmsq+FjNu5QD6PumErdUVZz4U0SYZnpNdRdE8nisrrWgK4+YSTKvgar1meJVK4nHAypGTve+hIK5Lf3XDYNwP6HbMyeNAC0CokAYzZ2B8lHL21oxY4qD2G9w4zPGu6WnvZTiJBSfWNkfViKh5zqggvCf3PRUaQ+v0= kmv@kmv-note"
  }
}

variable "vm_db_resources" {
  type = map
  default = {
    "core"      = "2"
    "memory"    = "2"
    "fraction"  = "20"
  }
}

variable "vm_web_resources" {
  type = map
  default = {
    "core"      = "2"
    "memory"    = "1"
    "fraction"  = "5"
  }
}
```

------

## Дополнительные задания (со звездочкой*)

**Настоятельно рекомендуем выполнять все задания под звёздочкой.**   
Их выполнение поможет глубже разобраться в материале. Задания под звёздочкой дополнительные (необязательные к выполнению) и никак не повлияют на получение вами зачета по этому домашнему заданию. 

### Задание 7*

Изучите сожержимое файла console.tf. Откройте terraform console, выполните следующие задания: 

1. Напишите, какой командой можно отобразить **второй** элемент списка test_list?
```
> local.test_list[1]
"staging"
```

2. Найдите длину списка test_list с помощью функции length(<имя переменной>).
```
> length(local.test_list)
3
```

3. Напишите, какой командой можно отобразить значение ключа admin из map test_map ?
```
> local.test_map["admin"]
"John"
```



4. Напишите interpolation выражение, результатом которого будет: "John is admin for production server based on OS ubuntu-20-04 with X vcpu, Y ram and Z virtual disks", используйте данные из переменных test_list, test_map, servers и функцию length() для подстановки значений.

```
> "${local.test_map["admin"]} is admin for ${local.test_list[2]} based on OS ${local.servers["production"]["image"]} with ${local.servers["production"]["cpu"]} vcpu, ${local.servers["production"]["ram"]} ram and ${length(local.servers["production"]["disks"])} virtual disks"

"John is admin for production based on OS ubuntu-20-04 with 10 vcpu, 40 ram and 4 virtual disks"

```
В качестве решения предоставьте необходимые команды и их вывод.

------
### Правила приема работы

В git-репозитории, в котором было выполнено задание к занятию "Введение в Terraform", создайте новую ветку terraform-02, закомитьте в эту ветку свой финальный код проекта. Ответы на задания и необходимые скриншоты оформите в md-файле в ветке terraform-02.

В качестве результата прикрепите ссылку на ветку terraform-02 в вашем репозитории.

**ВАЖНО! Удалите все созданные ресурсы**.


### Критерии оценки

Зачёт:

* выполнены все задания;
* ответы даны в развёрнутой форме;
* приложены соответствующие скриншоты и файлы проекта;
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку:

* задание выполнено частично или не выполнено вообще;
* в логике выполнения заданий есть противоречия и существенные недостатки. 
