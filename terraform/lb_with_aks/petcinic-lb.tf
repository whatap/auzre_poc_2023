resource "azurerm_public_ip" "petclinic" {
  name                = "PublicIPForPetclinicLB"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

#Create Load Balancer
resource "azurerm_lb" "petclinic-lb" {
  name                = "petclinic-lb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  frontend_ip_configuration {
    name                          = "petcliniclbfrontendip"
    #subnet_id                     = azurerm_subnet.petclinic_subnet.id
    #private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.petclinic.id
  }
  lifecycle {ignore_changes = [frontend_ip_configuration]}
}

#Create Loadbalancing Rules
resource "azurerm_lb_rule" "petclinic-inbound-rules" {
  loadbalancer_id                = azurerm_lb.petclinic-lb.id
  resource_group_name            = azurerm_resource_group.rg.name
  name                           = "petclinic-web-inbound-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 8080
  frontend_ip_configuration_name = "petcliniclbfrontendip"
  probe_id                       = azurerm_lb_probe.web-inbound-probe.id
  backend_address_pool_ids        = ["${azurerm_lb_backend_address_pool.petclinic-backend-pool.id}"]

}

#Create Probe
resource "azurerm_lb_probe" "web-inbound-probe" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.petclinic-lb.id
  name                = "petclinic-web-inbound-probe"
  port                = 8080
}

#Create Backend Address Pool
resource "azurerm_lb_backend_address_pool" "petclinic-backend-pool" {
  loadbalancer_id = azurerm_lb.petclinic-lb.id
  name            = "petclinic-backend-pool"
}

