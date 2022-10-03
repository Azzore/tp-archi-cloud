# Main (and only) VNet
resource "azurerm_virtual_network" "main" {
  name                = "project-${var.account_number}-vpc"
  location            = var.region
  resource_group_name = azurerm_resource_group.main.name

  address_space       = ["10.${var.account_number}.0.0/20"]

  tags = {
    "Name" : "project-${var.account_number}-vpc"
  }
}

# Subnet SN1/app
resource "azurerm_subnet" "app" {
  name                 = "project-${var.account_number}-sn1"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name

  address_prefixes     = ["10.${var.account_number}.1.0/24"]
}

# Subnet SN1/DB
resource "azurerm_subnet" "db" {
  name                 = "project-${var.account_number}-sn2"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.${var.account_number}.2.0/24"]
}

# Associate NSG with subnet 1 / app
resource "azurerm_subnet_network_security_group_association" "sn1_nsg1" {
  network_security_group_id = azurerm_network_security_group.main.id
  subnet_id                 = azurerm_subnet.app.id
}

# Associate NSG with subnet 2 / db
resource "azurerm_subnet_network_security_group_association" "sn2_nsg1" {
  network_security_group_id = azurerm_network_security_group.main.id
  subnet_id                 = azurerm_subnet.db.id
}
