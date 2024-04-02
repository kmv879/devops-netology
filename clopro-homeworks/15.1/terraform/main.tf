resource "yandex_compute_instance" "nat_instance" {
  name     = var.nat_name
  zone     = var.default_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id    = var.nat_image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_public.id
    ip_address = var.nat_ip
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "public" {
  name     = var.public_name
  hostname = "public"
  zone     = var.default_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id    = var.vm_image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_public.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "private" {
  name     = var.private_name
  hostname = "private"
  zone     = var.default_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id    = var.vm_image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_private.id
    nat       = false
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
