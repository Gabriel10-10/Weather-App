# --- 1. RESOURCE GROUP ---
resource "azurerm_resource_group" "project_rg" {
  name     = var.resource_group_name
  location = var.region
}

# --- 2. NETWORKING MODULE ---
module "networking" {
  source              = "./modules/networking"
  resource_group_name = azurerm_resource_group.project_rg.name
  location            = azurerm_resource_group.project_rg.location
  vnet_name           = var.vnet_name
  address_space       = var.address_space
}

# --- 3. CONTAINER REGISTRY (ACR) ---
resource "azurerm_container_registry" "acr" {
  name                = "cst8918group2acr"
  resource_group_name = azurerm_resource_group.project_rg.name
  location            = azurerm_resource_group.project_rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

# --- 4. TEST ENVIRONMENT ---
module "test_resources" {
  source    = "./modules/test_resources"
  rg_name   = azurerm_resource_group.project_rg.name
  location  = azurerm_resource_group.project_rg.location
  subnet_id = module.networking.test_subnet_id
}

# --- 5. PROD ENVIRONMENT ---
module "prod_resources" {
  source    = "./modules/prod_resources"
  rg_name   = azurerm_resource_group.project_rg.name
  location  = azurerm_resource_group.project_rg.location
  subnet_id = module.networking.prod_subnet_id
}

# --- 6. RBAC PERMISSIONS ---
# Allow Test AKS to pull from ACR
resource "azurerm_role_assignment" "acr_pull_test" {
  principal_id         = module.test_resources.cluster_principal_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
}

# Allow Prod AKS to pull from ACR
resource "azurerm_role_assignment" "acr_pull_prod" {
  principal_id         = module.prod_resources.cluster_principal_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
}
