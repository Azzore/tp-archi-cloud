# Application security group for our APP
resource "azurerm_application_security_group" "app" {
  name                = "project-${var.account_number}-asg1"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.region
}

# Application security group for our Database
resource "azurerm_application_security_group" "db" {
  name                = "project-${var.account_number}-asg2"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.region
}

# Main NSG associated with our subnets
resource "azurerm_network_security_group" "main" {
  name                = "project-${var.account_number}-nsg1"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.region
}

# Rule allow HTTP HTTPS and SSH from anywhere to ASG1 (app)
resource "azurerm_network_security_rule" "allow_http_https_ssh" {
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name

  name = "Allow-Web-All"

  protocol  = "Tcp"
  direction = "Inbound"
  access    = "Allow"
  priority  = 100

  source_port_range     = "*"
  source_address_prefix = "*"

  destination_application_security_group_ids = [azurerm_application_security_group.app.id]
  destination_port_ranges                    = ["80", "443", "22"]
}

# Rule to deny traffic to DB from anywhere on port 3306
resource "azurerm_network_security_rule" "deny_traffic_mysql" {
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name

  name = "Deny-inbound-DB-traffic"

  protocol  = "Tcp"
  direction = "Inbound"
  access    = "Deny"
  priority  = 120

  source_port_range     = "*"
  source_address_prefix = "*"

  destination_application_security_group_ids = [azurerm_application_security_group.db.id]
  destination_port_range                     = "3306"
}

# Rule to allow only ASG1 (our apps) to connect to database (asg2)
# Note that priority is lower than the deny rule
resource "azurerm_network_security_rule" "allow_asg1_asg2" {
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name

  name = "Allow-Webserver-DB-traffic"

  protocol  = "Tcp"
  direction = "Inbound"
  access    = "Allow"
  priority  = 110

  source_port_range                     = "*"
  source_application_security_group_ids = [azurerm_application_security_group.app.id]

  destination_application_security_group_ids = [azurerm_application_security_group.db.id]
  destination_port_range                     = "3306"
}