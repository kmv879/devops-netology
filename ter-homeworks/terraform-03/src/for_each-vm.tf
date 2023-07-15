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
