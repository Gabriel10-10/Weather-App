# ACR
output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "acr_id" {
  value = azurerm_container_registry.acr.id
}

# Test environment
output "test_cluster_name" {
  value = module.test_resources.cluster_name
}

output "test_kube_config" {
  value     = module.test_resources.cluster_kube_config_raw
  sensitive = true
}

output "test_redis_hostname" {
  value = module.test_resources.redis_hostname
}

output "test_redis_primary_key" {
  value     = module.test_resources.redis_primary_key
  sensitive = true
}

# Prod environment
output "prod_cluster_name" {
  value = module.prod_resources.cluster_name
}

output "prod_kube_config" {
  value     = module.prod_resources.cluster_kube_config_raw
  sensitive = true
}

output "prod_redis_hostname" {
  value = module.prod_resources.redis_hostname
}

output "prod_redis_primary_key" {
  value     = module.prod_resources.redis_primary_key
  sensitive = true
}