# Домашнее задание к занятию "Управляющие конструкции в коде Terraform"

### Цель задания

1. Научиться гибко управлять ресурсами в облаке Yandex Cloud с помощью Terraform.
2. Освоить работу с переменными Terraform

------


### Задание 1

1. Изучите проект.
2. Заполните файл personal.auto.tfvars
3. Инициализируйте проект, выполните код (он выполнится даже если доступа к preview нет).

Примечание: Если у вас не активирован preview доступ к функционалу "Группы безопасности" в Yandex Cloud - запросите доступ у поддержки облачного провайдера. Обычно его выдают в течении 24-х часов.

Приложите скриншот входящих правил "Группы безопасности" в ЛК Yandex Cloud  или скриншот отказа в предоставлении доступа к preview версии.

![Группы безопасности](/ter-homeworks/terraform-03/img/security.png "Группы безопасности")

------

### Задание 2

1. Создайте файл count-vm.tf. Опишите в нем создание двух **одинаковых** виртуальных машин с минимальными параметрами, используя мета-аргумент **count loop**.

```
resource "yandex_compute_instance" "web" {
  count = 2
  
  name        = "web-${count.index + 1}"
  
   resources {
    cores         = var.vm_web_resources["core"]
    memory        = var.vm_web_resources["memory"]
    core_fraction = var.vm_web_resources["fraction"]
  }
   boot_disk {
     initialize_params {
       image_id = data.yandex_compute_image.ubuntu.image_id
     }   
   }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
  metadata = {
   ssh-keys = local.ssh-keys
}   

```
2. Создайте файл for_each-vm.tf. Опишите в нем создание 2 **разных** по cpu/ram/disk виртуальных машин, используя мета-аргумент **for_each loop**. Используйте переменную типа list(object({ vm_name=string, cpu=number, ram=number, disk=number  })). При желании внесите в переменную все возможные параметры.

```
resource "yandex_compute_instance" "database" {
  for_each = {
     for index, vm in var.vm_db_resources:
     vm.vm_name => vm
     }
  name        = "${each.value.vm_name}"
  depends_on = [yandex_compute_instance.web] 
   resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.fraction
  }
   boot_disk {
     initialize_params {
       image_id = data.yandex_compute_image.ubuntu.image_id
     }   
   }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
  metadata = {
   ssh-keys = local.ssh-keys
  }  
}
```

3. ВМ из пункта 2.2 должны создаваться после создания ВМ из пункта 2.1.
4. Используйте функцию file в local переменной для считывания ключа ~/.ssh/id_rsa.pub и его последующего использования в блоке metadata, взятому из ДЗ №2.

```
locals {
   ssh-keys           = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
}
```
5. Инициализируйте проект, выполните код.

------

### Задание 3

1. Создайте 3 одинаковых виртуальных диска, размером 1 Гб с помощью ресурса yandex_compute_disk и мета-аргумента count.
2. Создайте одну **любую** ВМ. Используйте блок **dynamic secondary_disk{..}** и мета-аргумент for_each для подключения созданных вами дополнительных дисков.
```
resource "yandex_compute_disk" "empty-disk" {
  count      = 3
  name       = "empty-disk-${count.index}"
  type       = "network-hdd"
  zone       = var.default_zone
  size       = 1
  block_size = 4096
}

resource "yandex_compute_instance" "storage" {

  name        = "storage"
  depends_on  = [yandex_compute_disk.empty-disk]
   resources {
    cores         = var.vm_web_resources["core"]
    memory        = var.vm_web_resources["memory"]
    core_fraction = var.vm_web_resources["fraction"]
  }
   boot_disk {
     initialize_params {
       image_id = data.yandex_compute_image.ubuntu.image_id
     }   
   }
  
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.empty-disk.*.id
  content{
  disk_id = secondary_disk.value
  }
  
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
  metadata = {
   ssh-keys = local.ssh-keys
}   
}
```
3. Назначьте ВМ созданную в 1-м задании группу безопасности.

------

### Задание 4

1. Создайте inventory-файл для ansible.
Используйте функцию tepmplatefile и файл-шаблон для создания ansible inventory-файла из лекции.
Готовый код возьмите из демонстрации к лекции [**demonstration2**](https://github.com/netology-code/ter-homeworks/tree/main/demonstration2).
Передайте в него в качестве переменных имена и внешние ip-адреса ВМ из задания 2.1 и 2.2.

`ansible.tf`
```
resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/hosts.tftpl",
    {
       webservers =  yandex_compute_instance.web
       databases = yandex_compute_instance.database
       storage = [yandex_compute_instance.storage]
    }
  )
  filename = "${abspath(path.module)}/hosts.cfg"
}
```

`hosts.tftpl'

```
[webservers]

%{~ for i in webservers ~}

${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]} 
%{~ endfor ~}

[databases]

%{~ for i in databases ~}

${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]} 
%{~ endfor ~}

[storage]

%{~ for i in storage ~}

${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]} 
%{~ endfor ~}
```
2. Выполните код. Приложите скриншот получившегося файла.

![Inventory file](/ter-homeworks/terraform-03/img/inventory.png "Inventory file")

