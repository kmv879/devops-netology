resource "yandex_vpc_network" "my_vpc" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "subnet_public" {
  name           = "public"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.my_vpc.id
  v4_cidr_blocks = var.default_public_cidr
}
resource "yandex_vpc_subnet" "subnet_private" {
  name           = "private"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.my_vpc.id
  route_table_id = yandex_vpc_route_table.route_table.id
  v4_cidr_blocks = var.default_private_cidr
}
resource "yandex_vpc_route_table" "route_table" {
  network_id = yandex_vpc_network.my_vpc.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = var.nat_ip
  }
}
