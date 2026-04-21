terraform {
  required_version = ">= 1.5.0"

  # BACKEND IS COMMENTED OUT UNTIL RG IS CREATED
  /*
  backend "azurerm" {
    resource_group_name  = "cst8918-final-project-rg"
    storage_account_name = "finalprojectst"
    container_name       = "tfstate"
    key                  = "final-project.tfstate"
  }
  */

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