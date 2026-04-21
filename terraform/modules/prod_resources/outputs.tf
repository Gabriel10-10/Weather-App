
output "cluster_name" {
  value = azurerm_kubernetes_cluster.akscluster.name
}

output "cluster_id" {
  value = azurerm_kubernetes_cluster.akscluster.id
}

output "cluster_kube_config_raw" {
  value     = azurerm_kubernetes_cluster.akscluster.kube_config_raw
  sensitive = true
}


output "redis_hostname" {
  value = azurerm_redis_cache.redis_cache.hostname
}

output "redis_primary_key" {
  value     = azurerm_redis_cache.redis_cache.primary_access_key
  sensitive = true
}

output "cluster_principal_id" {
  value = azurerm_kubernetes_cluster.akscluster.kubelet_identity[0].object_id
}