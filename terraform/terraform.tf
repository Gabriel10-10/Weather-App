terraform {
  required_version = ">= 1.5.0"
  
  backend "azurerm" {
    resource_group_name  = "your-lab-rg-name"      # Change this to yours
    storage_account_name = "your-lab-storage-name" # Change this to yours
    container_name       = "tfstate"
    key                  = "final-project.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}