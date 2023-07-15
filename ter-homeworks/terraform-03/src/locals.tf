locals {
   ssh-keys           = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
}
