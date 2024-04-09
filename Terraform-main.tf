terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}
provider "yandex" {
  zone      = "ru-central1-a"
  token     = var.token
  cloud_id  = var.cloud
  folder_id = var.folder
}
resource "yandex_iam_service_account" "terradmin" {
  name        = "terradmin"
  description = "service account to manage Terraform"
}
resource "yandex_resourcemanager_folder_iam_member" "admin" {
  folder_id = var.folder
  role      = "admin"
  member    = "serviceAccount:${yandex_iam_service_account.terradmin.id}"
  depends_on = [
    yandex_iam_service_account.terradmin,
  ]
}

#_______________ALB________________________________
# resource "yandex_alb_target_group" "web-server-tg" {
#   name      = "web-server-tg"

#   target {
#     subnet_id = "${yandex_vpc_subnet.private-a.id}"
#     ip_address   = "${yandex_compute_instance.vm-nginx-1.network_interface.0.ip_address}"
#   }

#   target {
#     subnet_id = "${yandex_vpc_subnet.private-b.id}"
#     ip_address   = "${yandex_compute_instance.vm-nginx-2.network_interface.0.ip_address}"
#   }
# }
# resource "yandex_alb_http_router" "web-router" {
#   name      = "web-router"
# }
# resource "yandex_alb_virtual_host" "vh-for-web" {
#   name                    = "web-vh"
#   http_router_id          = "${yandex_alb_http_router.web-router.id}"
#   route {
#     name                  = "web"
#     http_route {
#       http_route_action {
#         backend_group_id  = "${yandex_alb_backend_group.web-backend-group.id}"
#         timeout           = "60s"
#       }
#     }
#   }
# }    
# resource "yandex_alb_backend_group" "web-backend-group" {
#   name      = "web-backend-group"
#   http_backend {
#     name = "web-http-backend"
#     weight = "1"
#     port = "80"
#     target_group_ids = ["${yandex_alb_target_group.web-server-tg.id}"]
#     load_balancing_config {
#       panic_threshold = 50
#       mode = "ROUND_ROBIN"
#     }    
#     healthcheck {
#       timeout = "5s"
#       interval = "5s"
#       http_healthcheck {
#         path  = "/"
#       }
#     }
#   }
# }
# resource "yandex_alb_load_balancer" "alb-balancer" {
#   name        = "alb-balancer"
#   network_id  = "${yandex_vpc_network.cod.id}"
#   security_group_ids = ["${yandex_vpc_security_group.ALB.id}", "${yandex_vpc_security_group.web-server.id}"]
#   allocation_policy {
#     location {
#       zone_id   = "ru-central1-a"
#       subnet_id = "${yandex_vpc_subnet.private-a.id}"
#     }
#   }

#   listener {
#     name = "alb-listener"
#     endpoint {
#       address {
#         external_ipv4_address {
#         }
#       }
#       ports = [ "80", "443" ]
#     }    
#     http {
#       handler {
#         http_router_id = "${yandex_alb_http_router.web-router.id}"
#       }
#     }
#   }
#   log_options {
#     discard_rule {
#       http_code_intervals = ["HTTP_2XX"]
#       discard_percent = 75
#     }
#   }
# }

#______________Instance___________________________
# resource "yandex_compute_instance" "vm-nginx-1" {
#   name               = "vm-nginx-1"
#   platform_id        = "standard-v1"
#   zone               = "ru-central1-a"
#   folder_id          = var.folder
#   service_account_id = yandex_iam_service_account.terradmin.id
#   depends_on         = [yandex_resourcemanager_folder_iam_member.admin]
#   hostname           = "ru-ngx-a.local"
#   resources {
#     cores  = 2
#     memory = 2
#   }

#   boot_disk {
#     mode = "READ_WRITE"
#     initialize_params {
#       image_id = "fd8hnnsnfn3v88bk0k1o"
#       size     = 20
#     }
#   }

#   network_interface {
#     subnet_id          = yandex_vpc_subnet.private-a.id
#     security_group_ids = ["${yandex_vpc_security_group.web-server.id}"]
#     nat                = "true"
#   }

#   metadata = {
#     user-data = "${file("meta-vm.txt")}"
#   }
#   timeouts {
#     create = "60m"
#   }
# }
# resource "yandex_compute_instance" "vm-nginx-2" {
#   name               = "vm-nginx-2"
#   platform_id        = "standard-v1"
#   zone               = "ru-central1-b"
#   folder_id          = var.folder
#   service_account_id = yandex_iam_service_account.terradmin.id
#   depends_on         = [yandex_resourcemanager_folder_iam_member.admin]
#   hostname           = "ru-ngx-b.local"
#   resources {
#     cores  = 2
#     memory = 2
#   }

#   boot_disk {
#     mode = "READ_WRITE"
#     initialize_params {
#       image_id = "fd8hnnsnfn3v88bk0k1o"
#       size     = 20
#     }
#   }

#   network_interface {
#     subnet_id          = yandex_vpc_subnet.private-b.id
#     security_group_ids = ["${yandex_vpc_security_group.web-server.id}"]
#     nat                = "true"
#   }

#   metadata = {
#     user-data = "${file("meta-vm.txt")}"
#   }
#   timeouts {
#     create = "60m"
#   }
# }
resource "yandex_compute_instance" "vm-kibana" {
  name               = "vm-kibana"
  platform_id        = "standard-v1"
  zone               = "ru-central1-a"
  hostname           = "ru-kbn-a.local"
  folder_id          = var.folder
  service_account_id = yandex_iam_service_account.terradmin.id
  depends_on         = [yandex_resourcemanager_folder_iam_member.admin]
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    mode = "READ_WRITE"
    initialize_params {
      image_id = "fd8hnnsnfn3v88bk0k1o"
      size     = 20
    }
  }
  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    security_group_ids = ["${yandex_vpc_security_group.kibana.id}"]
    nat                = "true"
  }

  metadata = {
    user-data = "${file("meta-vm.txt")}"
  }
  timeouts {
    create = "60m"
  }
}
resource "yandex_compute_instance" "vm-elastic" {
  name               = "vm-elastic"
  platform_id        = "standard-v1"
  zone               = "ru-central1-a"
  hostname           = "ru-elk-a.local"
  folder_id          = var.folder
  service_account_id = yandex_iam_service_account.terradmin.id
  depends_on         = [yandex_resourcemanager_folder_iam_member.admin]
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    mode = "READ_WRITE"
    initialize_params {
      image_id = "fd8hnnsnfn3v88bk0k1o"
      size     = 20
    }
  }
  network_interface {
    subnet_id          = yandex_vpc_subnet.private-a.id
    security_group_ids = ["${yandex_vpc_security_group.ELK.id}"]
    nat                = "true"
  }

  metadata = {
    user-data = "${file("meta-vm.txt")}"
  }
  timeouts {
    create = "60m"
  }
}
# resource "yandex_compute_instance" "vm-zbx-front" {
#   name               = "vm-zbx-front"
#   platform_id        = "standard-v1"
#   zone               = "ru-central1-a"
#   folder_id          = var.folder
#   hostname           = "ru-zbxf-a.local"
#   service_account_id = yandex_iam_service_account.terradmin.id
#   depends_on         = [yandex_resourcemanager_folder_iam_member.admin]
#   resources {
#     cores  = 2
#     memory = 2
#   }
#   boot_disk {
#     mode = "READ_WRITE"
#     initialize_params {
#       image_id = "fd8hnnsnfn3v88bk0k1o"
#       size     = 20
#     }
#   }
#   network_interface {
#     subnet_id          = yandex_vpc_subnet.public.id
#     security_group_ids = ["${yandex_vpc_security_group.zabbix-front.id}"]
#     nat                = "true"
#   }

#   metadata = {
#     user-data = "${file("meta-vm.txt")}"
#   }
#   timeouts {
#     create = "60m"
#   }
# }
# resource "yandex_compute_instance" "vm-zbx-db" {
#   name               = "vm-zbx-db"
#   platform_id        = "standard-v1"
#   zone               = "ru-central1-a"
#   folder_id          = var.folder
#   hostname           = "ru-zbxd-a.local"
#   service_account_id = yandex_iam_service_account.terradmin.id
#   depends_on         = [yandex_resourcemanager_folder_iam_member.admin]
#   resources {
#     cores  = 4
#     memory = 8
#   }
#   boot_disk {
#     mode = "READ_WRITE"
#     initialize_params {
#       image_id = "fd8hnnsnfn3v88bk0k1o"
#       size     = 40
#     }
#   }
#   network_interface {
#     subnet_id          = yandex_vpc_subnet.private-a.id
#     security_group_ids = ["${yandex_vpc_security_group.zabbix-back.id}"]
#     nat                = "true"
#   }

#   metadata = {
#     user-data = "${file("meta-vm.txt")}"
#   }
#   timeouts {
#     create = "60m"
#   }
# }
# resource "yandex_compute_instance" "vm-zbx-server" {
#   name               = "vm-zbx-server"
#   platform_id        = "standard-v1"
#   zone               = "ru-central1-a"
#   hostname           = "ru-zbxs-a.local"
#   folder_id          = var.folder
#   service_account_id = yandex_iam_service_account.terradmin.id
#   depends_on         = [yandex_resourcemanager_folder_iam_member.admin]
#   resources {
#     cores  = 2
#     memory = 2

#   }
#   boot_disk {
#     mode = "READ_WRITE"
#     initialize_params {
#       image_id = "fd8hnnsnfn3v88bk0k1o"
#       size     = 20
#     }
#   }

#   network_interface {
#     subnet_id          = yandex_vpc_subnet.private-a.id
#     security_group_ids = ["${yandex_vpc_security_group.zabbix-back.id}"]
#     nat                = "true"
#   }

#   metadata = {
#     user-data = "${file("meta-vm.txt")}"
#   }
#   timeouts {
#     create = "60m"
#   }
# }
resource "yandex_compute_instance" "vm-bastion" {
  name               = "vm-bastion"
  platform_id        = "standard-v1"
  zone               = "ru-central1-a"
  folder_id          = var.folder
  hostname           = "ru-bst-a.local"
  service_account_id = yandex_iam_service_account.terradmin.id
  depends_on         = [yandex_resourcemanager_folder_iam_member.admin]
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    mode = "READ_WRITE"
    initialize_params {
      image_id = "fd8hnnsnfn3v88bk0k1o"
      size     = 20
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    security_group_ids = ["${yandex_vpc_security_group.bastion-host.id}"]
    nat                = "true"
  }

  metadata = {
    user-data = "${file("meta.txt")}"
  }
  timeouts {
    create = "60m"
  }
}
#___________Snapshots_______________________
# resource "yandex_compute_snapshot_schedule" "instance-snap-schedule" {
#   name = "instance-snap-schedule"
#   schedule_policy {
#     expression = "0 0 ? * *"
#   }
#   snapshot_count = 7
#   disk_ids = [
#     "${yandex_compute_instance.vm-kibana.boot_disk[0].disk_id}",
#     "${yandex_compute_instance.vm-elastic.boot_disk[0].disk_id}",
#     "${yandex_compute_instance.vm-zbx-front.boot_disk[0].disk_id}",
#     "${yandex_compute_instance.vm-zbx-server.boot_disk[0].disk_id}",
#     "${yandex_compute_instance.vm-bastion.boot_disk[0].disk_id}",
#     "${yandex_compute_instance.vm-nginx-1.boot_disk[0].disk_id}",
#     "${yandex_compute_instance.vm-nginx-2.boot_disk[0].disk_id}",
#   ]
# }

#________________NETWORK_______________________
resource "yandex_vpc_network" "cod" {
  name = "cod"
}
resource "yandex_vpc_subnet" "private-a" {
  name           = "private-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.cod.id
  v4_cidr_blocks = ["10.10.10.0/28"]
}
resource "yandex_vpc_subnet" "private-b" {
  name           = "private-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.cod.id
  v4_cidr_blocks = ["10.10.11.0/28"]
}
resource "yandex_vpc_subnet" "public" {
  name           = "public"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.cod.id
  v4_cidr_blocks = ["10.10.20.0/28"]
}
#______________Security Group________________
resource "yandex_vpc_security_group" "bastion-host" {
  network_id = yandex_vpc_network.cod.id
  name       = "Bastion host via SSH"
  ingress {
    protocol       = "TCP"
    port           = "22"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol       = "TCP"
    port           = "22"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "yandex_vpc_security_group" "web-server" {
  network_id = yandex_vpc_network.cod.id
  name       = "SG for web server"
  ingress {
    protocol          = "TCP"
    predefined_target = "loadbalancer_healthchecks"
  }
  ingress {
    protocol          = "ANY"
    from_port         = 0
    to_port           = 65535
    predefined_target = "self_security_group"
  }
  ingress {
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion-host.id
  }
  ingress {
    protocol       = "TCP"
    port           = "443"
    v4_cidr_blocks = ["10.10.10.0/28", "10.10.11.0/28", "10.10.20.0/28"]
  }
  ingress {
    protocol       = "ANY"
    port           = "80"
    v4_cidr_blocks = ["10.10.10.0/28", "10.10.11.0/28", "10.10.20.0/28"]
  }
  ingress {
    protocol       = "ANY"
    from_port      = "10050"
    to_port        = "10053"
    description    = "Zabbix"
    v4_cidr_blocks = ["10.10.10.0/28", "10.10.11.0/28", "10.10.20.0/28"]
  }
  ingress {
    protocol       = "ANY"
    port           = "5601"
    description    = "Kibana"
    v4_cidr_blocks = ["10.10.10.0/28", "10.10.11.0/28", "10.10.20.0/28"]
  }
  ingress {
    protocol       = "ANY"
    port           = "9200"
    description    = "ELK"
    v4_cidr_blocks = ["10.10.10.0/28", "10.10.11.0/28", "10.10.20.0/28"]
  }
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

}
# resource "yandex_vpc_security_group" "zabbix-back" {
#   network_id = yandex_vpc_network.cod.id
#   name       = "SG for Zabbix DB & Server"
#   ingress {
#     protocol          = "ANY"
#     port              = "5432"
#     predefined_target = "self_security_group"
#   }
#   ingress {
#     protocol       = "ANY"
#     from_port      = "10050"
#     to_port        = "10053"
#     v4_cidr_blocks = ["10.10.10.0/28", "10.10.11.0/28", "10.10.20.0/28"]
#   }
#   ingress {
#     protocol       = "TCP"
#     port           = "5432"
#     v4_cidr_blocks = ["10.10.20.0/28"]
#   }
#   ingress {
#     protocol          = "TCP"
#     port              = "22"
#     security_group_id = yandex_vpc_security_group.bastion-host.id
#   }
#   egress {
#     protocol       = "ANY"
#     v4_cidr_blocks = ["0.0.0.0/0"]
#   }
# }
resource "yandex_vpc_security_group" "ELK" {
  network_id = yandex_vpc_network.cod.id
  name       = "SG for ELK"
  ingress {
    protocol       = "ANY"
    port           = "9200"
    v4_cidr_blocks = ["10.10.10.0/28", "10.10.11.0/28", "10.10.20.0/28"]
  }
  ingress {
    protocol          = "TCP"
    port              = "22"
    security_group_id = yandex_vpc_security_group.bastion-host.id
  }
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
# resource "yandex_vpc_security_group" "zabbix-front" {
#   network_id = yandex_vpc_network.cod.id
#   name       = "Web zabbix"
#   ingress {
#     protocol          = "TCP"
#     port              = "22"
#     security_group_id = yandex_vpc_security_group.bastion-host.id
#   }
#   ingress {
#     protocol       = "ANY"
#     port           = "443"
#     v4_cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     protocol       = "ANY"
#     port           = "80"
#     v4_cidr_blocks = ["0.0.0.0/0", "10.10.20.0/28"]
#   }
#   # ingress {
#   #   protocol          = "ANY"
#   #   port              = "5432"
#   #   security_group_id = yandex_vpc_security_group.zabbix-back.id
#   # }
#   # ingress {
#   #   protocol          = "ANY"
#   #   from_port         = "10050"
#   #   to_port           = "10053"
#   #   security_group_id = yandex_vpc_security_group.zabbix-back.id
#   # }
#   egress {
#     protocol       = "ANY"
#     v4_cidr_blocks = ["0.0.0.0/0"]
#   }
# }
resource "yandex_vpc_security_group" "kibana" {
  network_id = yandex_vpc_network.cod.id
  name       = "Kibana"
  ingress {
    protocol       = "ANY"
    port           = "5601"
    v4_cidr_blocks = ["10.10.10.0/28"]
  }
  ingress {
    protocol       = "ANY"
    port           = "22"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol       = "ANY"
    port           = "80"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol       = "ANY"
    port           = "443"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
# resource "yandex_vpc_security_group" "ALB" {
#   network_id = yandex_vpc_network.cod.id
#   name       = "SG for ALB"
#   ingress {
#     protocol       = "ANY"
#     port           = 80
#     v4_cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     protocol       = "ANY"
#     port           = 443
#     v4_cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     protocol       = "ANY"
#     v4_cidr_blocks = ["0.0.0.0/0"]
#   }
# }
