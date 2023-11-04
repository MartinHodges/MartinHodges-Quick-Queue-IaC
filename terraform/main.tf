terraform {
required_version = ">= 1.5.5"
  required_providers {
    restapi = {
      source = "Mastercard/restapi"
    }
  }
}

module "qq_vpc" {
  source = "./modules/vpc"
  vpc_name = "qq_vpc"
}

output "qq_vpc" {
  description = "qq_vpc"
  value = module.qq_vpc.vpc_desc
}

module "qq_k8s_master" {
  source = "./modules/public_vps"
  vps_name = "qq-k8s-master"
  vps_flavour = "std-2vcpu"
  vpc_id = module.qq_vpc.vpc_desc.id
  ssh_key = var.ssh_key
}

output "qq_k8s_master" {
  description = "qq_k8s_master"
  value = module.qq_k8s_master.v4_ips
}

module "qq_k8s_node_1" {
  source = "./modules/public_vps"
  vps_name = "qq-k8s-node-1"
  vps_flavour = "std-1vcpu"
  vpc_id = module.qq_vpc.vpc_desc.id
  ssh_key = var.ssh_key
}

output "qq_k8s_node_1" {
  description = "qq_k8s_node_1"
  value = module.qq_k8s_node_1.v4_ips
}

module "qq_k8s_node_2" {
  source = "./modules/public_vps"
  vps_name = "qq-k8s-node-2"
  vps_flavour = "std-1vcpu"
  vpc_id = module.qq_vpc.vpc_desc.id
  ssh_key = var.ssh_key
}

output "qq_k8s_node_2" {
  description = "qq-k8s_node_2"
  value = module.qq_k8s_node_2.v4_ips
}

resource "local_file" "inventory" {
  filename = "../ansible/inventory"
  content = templatefile("ansible_inventory.tftpl", {
    master_ip = module.qq_k8s_master.v4_ips.public
    node_ips = [
      module.qq_k8s_node_1.v4_ips.public,
      module.qq_k8s_node_2.v4_ips.public
    ]
  })
}

