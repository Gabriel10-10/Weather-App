# Test AKS Cluster
resource "azurerm_kubernetes_cluster" "akscluster" {
  name = "test-cluster"
  location = var.location
  resource_group_name = var.rg_name
  kubernetes_version = "1.35.1"
  dns_prefix = "test-dns" 

  default_node_pool {
    name = "default"
    vm_size = "Standard_B2s"
    node_count = 1
    enable_auto_scaling = false
    vnet_subnet_id = var.subnet_id 
  }
  oidc_issuer_enabled = true
  network_profile {
    network_plugin = "azure"
    service_cidr   = "10.100.0.0/16"
    dns_service_ip = "10.100.0.10"
  }

  identity {
    type = "SystemAssigned"
  }
}

# Azure Redis Cache
resource "azurerm_redis_cache" "redis_cache" {
  name = "testenv-redis-cache"
  location = var.location
  resource_group_name = var.rg_name
  capacity = 0
  family = "C"
  sku_name = "Basic"
  
}