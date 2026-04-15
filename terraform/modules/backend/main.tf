# 1. Networking Module
module "networking" {
  source              = "./modules/networking"
  resource_group_name = "cst8918-final-project-group-2"
  location            = "canadacentral"
  vnet_name           = "final-project-vnet"
  address_space       = ["10.0.0.0/14"]
}

# 2. Member C's AKS Module
module "aks" {
  source              = "./modules/aks"
  resource_group_name = "cst8918-final-project-group-2"
  location            = "canadacentral"
  subnet_id           = module.networking.prod_subnet_id 
}

# --- OUTPUTS ---
output "networking_prod_subnet_id" {
  value = module.networking.prod_subnet_id
}