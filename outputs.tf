output "vm-bastion" {
  description = "NAT ip vm-bastion"
  value       = yandex_compute_instance.vm-bastion.network_interface.0.nat_ip_address
}
# output "vm-zbx-db" {
#   description = "Internal ip vm-zbx-db"
#   value       = yandex_compute_instance.vm-zbx-db.network_interface.0.ip_address
# }
# output "vm-nginx-1" {
#   description = "Internal ip vm-nginx-1"
#   value       = yandex_compute_instance.vm-nginx-1.network_interface.0.ip_address
# }
# output "vm-nginx-2" {
#   description = "Internal ip vm-nginx-2"
#   value       = yandex_compute_instance.vm-nginx-2.network_interface.0.ip_address
# }
# output "vm-zbx-front" {
#   description = "IP vm-zbx-front"
#   value       = yandex_compute_instance.vm-zbx-front.network_interface.0.ip_address
# }
# output "vm-zbx-front-nat" {
#   description = "NAT ip vm-zbx-front"
#   value       = yandex_compute_instance.vm-zbx-front.network_interface.0.nat_ip_address
# }
output "vm-kibana" {
  description = "NAT ip vm-kibana"
  value       = yandex_compute_instance.vm-kibana.network_interface.0.ip_address
}
output "vm-kibana-nat" {
  description = "NAT ip vm-kibana"
  value       = yandex_compute_instance.vm-kibana.network_interface.0.nat_ip_address
}
# output "ALB" {
#   description = "NAT ip ALB"
#   value       = yandex_alb_load_balancer.alb-balancer.listener.0.endpoint.0.address.0.external_ipv4_address
# }
output "vm-elastic" {
  description = "Internal ip vm-elastic"
  value       = yandex_compute_instance.vm-elastic.network_interface.0.ip_address
}
output "vm-elastic-nat" {
  description = "NAT ip vm-elastic"
  value       = yandex_compute_instance.vm-elastic.network_interface.0.nat_ip_address
}
# output "vm-zbx-server" {
#   description = "Internal ip vm-zbx-server"
#   value       = yandex_compute_instance.vm-zbx-server.network_interface.0.ip_address
# }