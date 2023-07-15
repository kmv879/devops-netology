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
