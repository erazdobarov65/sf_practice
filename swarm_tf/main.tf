terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~>0.65.0"
    }
  }
}

provider "yandex" {
  token     = "t1.9euelZqMy47LmMmVi8aal8mTnZCUk-3rnpWaz8iem47Hmc6dz5OOnZbHy4vl9PdBDWpU-e9kcWqo3fT3ATxnVPnvZHFqqM3n9euelZqMk5GVj8nGkZ2clc7Pj5XNnu_8zef1656VmsuQx5icy5mKno2ei8fGm5rJ7_3F656VmoyTkZWPycaRnZyVzs-Plc2e.FgquZ2lOL1oZVTmudOX0Ot3wSWYt0pugt-iDgX70h0R9Vfg-qLdbdc3uMnm_2hgdewPmVMnIw_fUMPzdXYXyCQ"
  cloud_id  = "b1gm19nmjb0pa1kch69i"
  folder_id = "b1gtv6t2104oglbvpco8"
  zone      = "ru-central1-a"
}

resource "yandex_vpc_network" "network" {
  name = "swarm-network"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

module "swarm_cluster" {
  source        = "./modules/instance"
  vpc_subnet_id = yandex_vpc_subnet.subnet.id
  managers      = 1
  workers       = 2
}
