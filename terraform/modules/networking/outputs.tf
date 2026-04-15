output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Location of the created resource group"
  value       = azurerm_resource_group.main.location
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.vnet.name
}

output "prod_subnet_id" {
  description = "ID of the prod subnet"
  value       = azurerm_subnet.prod.id
}

output "test_subnet_id" {
  description = "ID of the test subnet"
  value       = azurerm_subnet.test.id
}

output "dev_subnet_id" {
  description = "ID of the dev subnet"
  value       = azurerm_subnet.dev.id
}

output "admin_subnet_id" {
  description = "ID of the admin subnet"
  value       = azurerm_subnet.admin.id
}
