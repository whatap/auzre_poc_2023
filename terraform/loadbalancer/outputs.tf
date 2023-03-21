output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "public_ip_address" {

  value       = [azurerm_linux_virtual_machine.petclinic.*.public_ip_address]
}

output "frontend_ip_configuration" {
  description = "Load Balancer's frontend IP configuration as described here https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#frontend_ip_configuration."
  value       = azurerm_lb.petclinic-lb.frontend_ip_configuration
}