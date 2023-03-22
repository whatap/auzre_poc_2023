output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "public_ip_address" {

  value       = [azurerm_linux_virtual_machine.petclinic.*.public_ip_address]
}

output "frontend_ip_configuration" {
  description = "Load Balancer's frontend IP"
  value       = azurerm_public_ip.petclinic.ip_address
}


