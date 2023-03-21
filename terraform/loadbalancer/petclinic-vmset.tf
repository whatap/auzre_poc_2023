resource "azurerm_network_interface" "petclinic" {
  name                = "petclinic-${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  count               = var.vmcount

  ip_configuration {
    name                          = "petclinic-ipconfig-${count.index + 1}"
    subnet_id                     = azurerm_subnet.petclinic_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "petclinic-pool" {
  count                   = var.vmcount
  network_interface_id    = azurerm_network_interface.petclinic.*.id[count.index]
  ip_configuration_name   = azurerm_network_interface.petclinic.*.ip_configuration.0.name[count.index]
  backend_address_pool_id = azurerm_lb_backend_address_pool.petclinic-backend-pool.id

}

#Availability Set - Fault Domains [Rack Resilience]
resource "azurerm_availability_set" "petclinic" {
  name                         = "petclinic"
  location                     = azurerm_resource_group.rg.location
  resource_group_name          = azurerm_resource_group.rg.name
  platform_fault_domain_count  = var.vmcount
  platform_update_domain_count = var.vmcount
  managed                      = true
  tags = {
    environment = "Demo"
  }
}

#Create Linux Virtual Machines Workloads
resource "azurerm_linux_virtual_machine" "petclinic" {

  name                  = "petclinic-linuxvm${count.index}"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  availability_set_id   = azurerm_availability_set.petclinic.id
  network_interface_ids = ["${element(azurerm_network_interface.petclinic.*.id, count.index)}"]
  size                  =  "Standard_B1s"  # "Standard_D2ads_v5" # "Standard_DC1ds_v3" "Standard_D2s_v3"
  count                 = var.vmcount

  #Create Operating System Disk
  os_disk {
    name                 = "petclinic_disk${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS" #Consider Storage Type
  }

  #Reference Source Image from Publisher
  source_image_reference {
    publisher = "Canonical"                    #az vm image list -p "Canonical" --output table
    offer     = "0001-com-ubuntu-server-focal" # az vm image list -p "Canonical" --output table
    sku       = "20_04-lts-gen2"               #az vm image list -s "20.04-LTS" --output table
    version   = "latest"
  }

  #Create Computer Name and Specify Administrative User Credentials
  computer_name                   = "petclinic-linux-vm${count.index}"
  admin_username                  = "whatap"
  disable_password_authentication = true

  #Create SSH Key for Secured Authentication - on Windows Management Server [Putty + PrivateKey]
  admin_ssh_key {
    username   = "whatap"
    public_key = var.hsnamPubKey
  }

  #Deploy Custom Data on Hosts
  custom_data    = base64encode(data.template_file.linux-vm-cloud-init.rendered) 

}

data "template_file" "linux-vm-cloud-init" {
  template = file("scripts/spring-petstore-docker.sh")
  vars ={
    DBUSER = azurerm_mysql_flexible_server.petclinic.administrator_login
    DBPASSWD = var.mysqladminloginpasswd
    MYSQL_ENDPOINT = azurerm_mysql_flexible_server.petclinic.fqdn
  }

  depends_on = [ azurerm_mysql_flexible_server.petclinic ]
}