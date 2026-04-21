# Prod AKS Cluster
#tfsec:ignore:azure-container-limit-authorized-ips
resource "azurerm_kubernetes_cluster" "akscluster" {
  name                = "prod-cluster"
  location            = var.location
  resource_group_name = var.rg_name
  kubernetes_version  = "1.34.4"
  dns_prefix          = "prod-dns"

  default_node_pool {
    name                = "default"
    vm_size             = "Standard_B2s"
    min_count           = 1
    node_count          = 1
    max_count           = 3
    enable_auto_scaling = true
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
  name                = "prod-redis-ramy-8918"
  location            = var.location
  resource_group_name = var.rg_name
  capacity            = 1
  family              = "C"
  sku_name            = "Standard"
}