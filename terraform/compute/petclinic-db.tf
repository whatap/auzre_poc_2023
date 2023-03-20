


# Manages the MySQL Flexible Server
resource "azurerm_mysql_flexible_server" "petclinic" {
  location                     = azurerm_resource_group.rg.location
  name                         = "petclinic-mysqlfs-${random_string.name.result}"
  resource_group_name          = azurerm_resource_group.rg.name
  administrator_login          = var.mysqladminloginuser
  administrator_password       = var.mysqladminloginpasswd
  backup_retention_days        = 7
  delegated_subnet_id          = azurerm_subnet.my_terraform_subnet_delegated.id
  geo_redundant_backup_enabled = false
  private_dns_zone_id          = azurerm_private_dns_zone.petclinic.id
  sku_name                     = "GP_Standard_D2ds_v4"
  version                      = "8.0.21"
  zone                         = "1"

  high_availability {
    mode                      = "SameZone"
  }
  maintenance_window {
    day_of_week  = 0
    start_hour   = 8
    start_minute = 0
  }
  storage {
    iops    = 360
    size_gb = 20
  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.petclinic]
}

resource "azurerm_mysql_flexible_server_firewall_rule" "petclinic" {
  name                = "petclinic"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.petclinic.name
  start_ip_address    =  var.subnet_start
  end_ip_address      =  var.subnet_end
}


output "mysql_server_fqdn" {
  description = "MySQL Server FQDN"
  value = azurerm_mysql_flexible_server.petclinic.fqdn
}

output "admin_login" {
  value = azurerm_mysql_flexible_server.petclinic.administrator_login
}

output "admin_password" {
  value     = var.mysqladminloginpasswd
}

output "mysql_server_database_name" {
  value = azurerm_mysql_flexible_server.petclinic.name
}
