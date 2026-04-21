
# Network
module "networking" {
  source = "./modules/networking"

  resource_group_name = var.resource_group_name
  location            = var.region
  vnet_name           = var.vnet_name
  address_space       = var.address_space
}

# 2. Member C's AKS Module
resource "azurerm_container_registry" "acr" {
  name                = "cst8918group2acr"
  resource_group_name = var.resource_group_name
  location            = var.region
  sku                 = "Basic"
  admin_enabled       = true
}

# Test environment resources
module "test_resources" {
  source    = "./modules/test_resources"
  location  = var.region
  rg_name   = var.resource_group_name
  subnet_id = module.networking.test_subnet_id
}

# Prod environment resources
module "prod_resources" {
  source    = "./modules/prod_resources"
  location  = var.region
  rg_name   = var.resource_group_name
  subnet_id = module.networking.prod_subnet_id
}

# Allow test AKS to pull from ACR
resource "azurerm_role_assignment" "acr_pull_test" {
  principal_id         = module.test_resources.cluster_principal_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
}

# Allow prod AKS to pull from ACR
resource "azurerm_role_assignment" "acr_pull_prod" {
  principal_id         = module.prod_resources.cluster_principal_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
}