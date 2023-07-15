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
}
