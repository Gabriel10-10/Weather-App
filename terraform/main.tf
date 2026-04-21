# --- 1. TERRAFORM & PROVIDER CONFIG ---
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  # BACKEND IS COMMENTED OUT TO USE LOCAL STATE FOR NEW SUBSCRIPTION
  /*
  backend "azurerm" {
    resource_group_name  = "cst8918-final-project-rg"
    storage_account_name = "finalprojectst"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
  */
}

provider "azurerm" {
  features {}
}

# --- 2. RESOURCE GROUP ---
# We create this here because it doesn't exist in your new subscription yet.
resource "azurerm_resource_group" "project_rg" {
  name     = "cst8918-final-project-group-2"
  location = "canadacentral"
}

# --- 3. NETWORKING ---
module "networking" {
  source              = "./modules/networking"
  resource_group_name = azurerm_resource_group.project_rg.name
  location            = azurerm_resource_group.project_rg.location
  vnet_name           = "final-project-vnet"
  address_space       = ["10.0.0.0/14"]
}

# --- 4. CONTAINER REGISTRY (ACR) ---
resource "azurerm_container_registry" "acr" {

  sku                 = "Basic"
  admin_enabled       = true
}

# --- 5. TEST RESOURCES ---
module "test_resources" {
  source    = "./modules/test_resources"
  rg_name   = azurerm_resource_group.project_rg.name
  location  = azurerm_resource_group.project_rg.location
  subnet_id = module.networking.test_subnet_id
}

# --- 6. PROD RESOURCES ---
module "prod_resources" {
  source    = "./modules/prod_resources"
  rg_name   = azurerm_resource_group.project_rg.name
  location  = azurerm_resource_group.project_rg.location
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