terraform {
  required_version = ">= 1.5.0"

  backend "azurerm" {
    resource_group_name  = "cst8918-final-project-group-2"
    storage_account_name = "ramytfstate1h4mp4" # Use the name from your logs!
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