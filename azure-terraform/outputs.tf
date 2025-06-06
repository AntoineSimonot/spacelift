// ────────────────────────────────────────────────────────────────────────────
// outputs.tf
// ────────────────────────────────────────────────────────────────────────────

output "azure_ip" {
  description = "Adresse IP publique de la VM Azure"
  value       = azurerm_public_ip.public_ip.ip_address
}

output "azure_vnet_id" {
  description = "ID du Virtual Network Azure"
  value       = azurerm_virtual_network.vnet.id
}

output "azure_subnet_id" {
  description = "ID du Subnet Azure"
  value       = azurerm_subnet.subnet.id
}

output "azure_nic_id" {
  description = "ID de la Network Interface Azure"
  value       = azurerm_network_interface.nic.id
}

output "azure_vm_id" {
  description = "ID de la VM Ubuntu Azure"
  value       = azurerm_linux_virtual_machine.vm.id
}
