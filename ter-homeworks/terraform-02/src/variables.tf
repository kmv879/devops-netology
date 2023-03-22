###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}



###ssh vars

variable "vm_ssh" {
  type = map
  default = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8ZlCrxqfOR72bWaqI57RYWL7PNQOBqSs+qNoEZKddviWoozta0K1v1+usSNeqFMKMhF9OAGreE/7cdZRj0XArrYl6qXVmpJEfeiKCRLRi3XrHBmhF7FXnVpm45DR6YJ3mI6VpRg4ddmBs+oSr0mme431vgYluW6pRFBhdRZBAIn7Ip/zhQD2JQdkuqq4jrjbCY1QDl/UEwPlk7YOwqqDis6a710Xam9mBC+Owv6Tot2K1xwG4eq6+FsxLlp7eOeIsp72s44fPyGWeEaZikJz1hxyiaDg5Bv7Rrp3Ppy0rnKUmYE556umAaQ/HQsLVNPpPhV/qklpPZZMtY06yPBFu8rI7aVRNtGFmsq+FjNu5QD6PumErdUVZz4U0SYZnpNdRdE8nisrrWgK4+YSTKvgar1meJVK4nHAypGTve+hIK5Lf3XDYNwP6HbMyeNAC0CokAYzZ2B8lHL21oxY4qD2G9w4zPGu6WnvZTiJBSfWNkfViKh5zqggvCf3PRUaQ+v0= kmv@kmv-note"
  }
}


