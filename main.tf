terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.140.1"
    }
  }
}

provider "yandex" {
     cloud_id  = var.cloud_id
     folder_id = var.folder_id
     service_account_key_file = file("./authorized_key.json")
   }

resource "yandex_vpc_network" "network" {
  name = "my-network"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "my-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_compute_instance" "vm" {
  count = 2

  name        = "web-server-${count.index}"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd85im9midded6jlfak4" # Ubuntu 22.04
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  metadata = {
    user-data = <<-EOF
      #cloud-config
      package_upgrade: true
      packages:
        - nginx
      runcmd:
        - systemctl enable nginx
        - systemctl start nginx
    EOF
  }
}

resource "yandex_lb_target_group" "web-servers" {
  name      = "web-servers-tg"
  region_id = "ru-central1"

  target {
    subnet_id = yandex_vpc_subnet.subnet.id
    address   = yandex_compute_instance.vm[0].network_interface.0.ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.subnet.id
    address   = yandex_compute_instance.vm[1].network_interface.0.ip_address
  }
}

resource "yandex_lb_network_load_balancer" "web-balancer" {
  name = "web-balancer"

  listener {
    name = "http-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.web-servers.id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}

output "balancer_ip" {
  value = yandex_lb_network_load_balancer.web-balancer.listener[*].external_address_spec[*].address
}