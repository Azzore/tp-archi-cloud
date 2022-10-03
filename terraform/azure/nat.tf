# Nat gateway in order to have more control over internet access
# The NAT Gateway will be used to connect our 2 subnets to internet
resource "azurerm_nat_gateway" "main" {
  name                = "project-${var.account_number}-nat"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  tags = {
    "Name" : "project-${var.account_number}-nat"
  }
}

# Public IP for NAT Gateway
resource "azurerm_public_ip" "nat" {
  name                = "project-${var.account_number}-publicIP"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  allocation_method   = "Static"
  sku                 = "Standard"
}

# Assotiation between our public IP and NAT Gateway
resource "azurerm_nat_gateway_public_ip_association" "main" {
  nat_gateway_id       = azurerm_nat_gateway.main.id
  public_ip_address_id = azurerm_public_ip.nat.id
}

# Assotiation between our NAT Gateway and SN1 (app subnet)
resource "azurerm_subnet_nat_gateway_association" "app_internet" {
  nat_gateway_id = azurerm_nat_gateway.main.id
  subnet_id      = azurerm_subnet.app.id
}

# Assotiation between our NAT Gateway and SN2 (DB subnet)
resource "azurerm_subnet_nat_gateway_association" "db_internet" {
  nat_gateway_id = azurerm_nat_gateway.main.id
  subnet_id      = azurerm_subnet.db.id
}
