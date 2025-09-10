module "network" {
  source = "../../modules/network"
}

output "resource_group_name" {
  value = module.network.resource_group_name
}

output "vnet_id" {
  value = module.network.vnet_id
}

output "subnet_id" {
  value = module.network.subnet_id
}