# Test AKS Cluster
#tfsec:ignore:azure-container-limit-authorized-ips
resource "azurerm_kubernetes_cluster" "akscluster" {
  name                = "test-cluster"
  location            = var.location
  resource_group_name = var.rg_name
  kubernetes_version  = "1.34.4"
  dns_prefix          = "test-dns"

  default_node_pool {
    name                = "default"
    vm_size             = "Standard_B2s"
    node_count          = 1
    enable_auto_scaling = false
    vnet_subnet_id      = var.subnet_id
  }

  oidc_issuer_enabled               = true
  role_based_access_control_enabled = true

  api_server_access_profile {
    authorized_ip_ranges = ["0.0.0.0/0"]
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    service_cidr   = "10.100.0.0/16"
    dns_service_ip = "10.100.0.10"
  }

  identity {
    type = "SystemAssigned"
  }
}

# Azure Redis Cache
resource "azurerm_redis_cache" "redis_cache" {
  name                = "test-redis-ramy-8918"
  location            = var.location
  resource_group_name = var.rg_name
  capacity            = 0
  family              = "C"
  sku_name            = "Basic"

}