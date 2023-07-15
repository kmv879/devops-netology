###yandex_compute vars

variable "wm_web_image_name" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "image name"
}

variable "wm_web_role" {
  type        = string
  default     = "web"
  description = "web role"
} 

variable "wm_web_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "platform id"
}

variable "wm_db_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "platform id"
}

variable "vm_web_resources" {
  type = map
  default = {
    "core"      = "2"
    "memory"    = "1"
    "fraction"  = "5"
  }
}

variable "vm_db_resources" {
  type = list(object(
  {
     vm_name=string,
     cpu=number,
     ram=number,
     fraction=number
  }))
  default = [
  {
     vm_name = "main",
     cpu = 4,
     ram = 4,
     fraction=5
  },
  {
     vm_name = "replica",
     cpu = 2,
     ram = 2,
     fraction=5
  }
  ]
}
     

