# --- 1. RESOURCE GROUP ---
resource "azurerm_resource_group" "project_rg" {
  name     = "cst8918-final-project-group-2"
  location = "canadacentral"
}

# --- 2. NETWORKING MODULE ---
module "networking" {
  source              = "./modules/networking"
  resource_group_name = azurerm_resource_group.project_rg.name
  location            = azurerm_resource_group.project_rg.location
  vnet_name           = "final-project-vnet"
  address_space       = ["10.0.0.0/14"]
}

# --- 3. CONTAINER REGISTRY (ACR) ---
# Using the random suffix for global uniqueness
resource "azurerm_container_registry" "acr" {
  name                = "cst8918group2ACRramy"
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

# --- 7. BACKEND INFRASTRUCTURE ---
# We keep this here so Terraform can manage the storage it's using for state
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_storage_account" "tfstate_storage" {
  name                     = "ramytfstate${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.project_rg.name
  location                 = azurerm_resource_group.project_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tfstate_container" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate_storage.name
  container_access_type = "private"
}