resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}


data "yandex_compute_image" "ubuntu" {
  family = var.wm_web_image_name
}
resource "yandex_compute_instance" "platform_db" {
  name        = "${ local.vm_name }-db"
  platform_id = var.wm_db_platform_id
  resources {
    cores         = var.vm_db_resources["core"]
    memory        = var.vm_db_resources["memory"]
    core_fraction = var.vm_db_resources["fraction"]
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

  metadata = var.vm_ssh
}

resource "yandex_compute_instance" "platform_web" {
  name        = "${ local.vm_name }-web"
  platform_id = var.wm_web_platform_id
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
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = var.vm_ssh

}
