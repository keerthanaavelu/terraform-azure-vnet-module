output "vnet_id" {
  description = "The ID of the created virtual network"
  value       = azurerm_virtual_network.this.id
}

output "subnet_id" {
  description = "The ID of the created subnet"
  value       = azurerm_subnet.this.id
}

output "nsg_id" {
  description = "The ID of the created network security group"
  value       = azurerm_network_security_group.this.id
}
