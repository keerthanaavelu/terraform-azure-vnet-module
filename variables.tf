variable "resource_group_name" {
  description = "Name of the resource group where VNet resources will be created"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "address_space" {
  description = "Address space for the VNet"
  type        = list(string)
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "subnet_prefix" {
  description = "Address prefix for the subnet"
  type        = list(string)
}

variable "nsg_name" {
  description = "Name of the network security group"
  type        = string
}

# --- Intentionally rigid: single NSG rule as flat fields ---
variable "nsg_rule_name" {
  description = "Name of the single NSG inbound rule"
  type        = string
}

variable "nsg_rule_priority" {
  description = "Priority of the NSG rule"
  type        = number
}

variable "nsg_rule_port" {
  description = "Destination port for the NSG rule"
  type        = string
}

variable "nsg_rule_source_address_prefix" {
  description = "Source address prefix allowed by the NSG rule"
  type        = string
  default     = "*"
}
