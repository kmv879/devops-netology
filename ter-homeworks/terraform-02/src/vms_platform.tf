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

