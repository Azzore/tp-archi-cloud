# Main resource group
resource "azurerm_resource_group" "main" {
  name     = "project-${var.account_number}-rg"
  location = var.region
}
