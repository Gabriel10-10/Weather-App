output "resource_group_name" {
  value = var.resource_group_name
}

output "resource_group_location" {
  value = var.location
}

output "prod_subnet_id" {
  value = azurerm_subnet.prod.id
}

output "test_subnet_id" {
  value = azurerm_subnet.test.id
}