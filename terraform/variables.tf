variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "cst8918-final-project-group-2"
}

variable "region" {
  description = "Azure region where all resources will be deployed"
  type        = string
  default     = "canadacentral"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "cst8918-final-project-vnet"
}

variable "address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/14"]
}


