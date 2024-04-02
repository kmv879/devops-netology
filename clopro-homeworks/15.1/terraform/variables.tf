###cloud vars
variable "token" {
  type        = string
}

variable "cloud_id" {
  type        = string
}

variable "folder_id" {
  type        = string
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
}
variable "default_public_cidr" {
  type        = list(string)
  default     = ["192.168.10.0/24"]
}

variable "default_private_cidr" {
  type        = list(string)
  default     = ["192.168.20.0/24"]
}

variable "vpc_name" {
  type        = string
  default     = "my_vpc"
}

variable "nat_ip" {
  default = "192.168.10.254"
}

variable "nat_image_id" {
  default = "fd80mrhj8fl2oe87o4e1"
}

variable "vm_image_id" {
  default = "fd8dmsb2cgoabg4qelih"
}

variable "nat_name" {
  default = "nat-instance"
}

variable "public_name" {
  default = "public"
}

variable "private_name" {
  default = "private"
}

