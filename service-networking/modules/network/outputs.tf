output "resource_group_name" {
  value = azurerm_resource_group.example.name
}

output "vnet_id" {
  value = azurerm_virtual_network.example.id
}

output "subnet_id" {
  value = azurerm_subnet.example.id
}