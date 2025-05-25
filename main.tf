   terraform {
     required_providers {
       yandex = {
         source  = "yandex-cloud/yandex"
         version = "~> 0.140.1"
       }
     }
   }

   provider "yandex" {
     cloud_id  = var.cloud_id
     folder_id = var.folder_id
     service_account_key_file = file("./authorized_key.json")
   }
   
   
resource "yandex_compute_instance" "vm_instance1" {
  name            = "my-vm-01"
  zone            = "ru-central1-a"
  hostname    = "my-vm-01" #формирует FDQN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = "standard-v3"

  resources {
    cores  = 2
    memory = 1
    core_fraction = 20
  }


  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = "fd85im9midded6jlfak4"
      size     = 10
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  # metadata = {
  #   ssh-keys = var.ssh_public_key
  # }
  
  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
    "monitoring-agent" = "1" # Важно! Это добавит агент Yandex Monitoring.
  }
  

  service_account_id = var.service_account_id
  
}




resource "yandex_compute_instance" "vm_instance2" {
  name            = "my-vm-02"
  zone            = "ru-central1-a"
  hostname    = "my-vm-02" #формирует FDQN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = "standard-v3"

  resources {
    cores  = 2
    memory = 1
    core_fraction = 20
  }


  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = "fd85im9midded6jlfak4"
      size     = 10
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  # metadata = {
  #   ssh-keys = var.ssh_public_key
  # }
  
  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
    "monitoring-agent" = "1" # Важно! Это добавит агент Yandex Monitoring.
  }
  

  service_account_id = var.service_account_id
  
}
