terraform {
  required_version = "~> 1.5"

  backend "azurerm" {
    resource_group_name  = "ramy-cst8918-tf-backend" # Use the RG from your lab
    storage_account_name = "ramy8918tfstorage2026"  # Use the SA from your lab
    container_name       = "tfstate"
    key                  = "final-project.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.96.0"
    }
  }
}

provider "azurerm" {
  features {}
}