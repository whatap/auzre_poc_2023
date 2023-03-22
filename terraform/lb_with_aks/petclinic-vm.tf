


# Create network interface
resource "azurerm_network_interface" "my_terraform_nic" {
  name                = "daelimNIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "daelim_nic_configuration"
    subnet_id                     = azurerm_subnet.petclinic_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "myterraform_sga" {
  network_interface_id      = azurerm_network_interface.my_terraform_nic.id
  network_security_group_id = azurerm_network_security_group.petclinic_nsg.id
}


  # Create virtual machine
  resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
    name                  = "daelimVM"
    location              = azurerm_resource_group.rg.location
    resource_group_name   = azurerm_resource_group.rg.name
    network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
    size                  = "Standard_DS1_v2"

    os_disk {
      name                 = "daelimOsDisk"
      caching              = "ReadWrite"
      storage_account_type = "Premium_LRS"
    }

    source_image_reference {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts-gen2"
      version   = "latest"
    }

    computer_name                   = "daelimvm"
    admin_username                  = "whatap"
    disable_password_authentication = true

    admin_ssh_key {
      username   = "whatap"
      public_key = var.hsnamPubKey
    }
custom_data = base64encode(templatefile("./scripts/whatap-database-monitoring.sh", {
    DBUSER = azurerm_mysql_flexible_server.petclinic.administrator_login
    DBPASSWD = var.mysqladminloginpasswd
    MYSQL_ENDPOINT = azurerm_mysql_flexible_server.petclinic.fqdn
  }))
lifecycle {ignore_changes = [network_interface_ids]}    
  }
