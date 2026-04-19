# 1. Networking Module
module "networking" {
  source              = "./modules/networking"
  resource_group_name = var.rg_name
  location            = var.location
  vnet_name           = "final-project-vnet"
  address_space       = ["10.0.0.0/14"]
}




