provider "azurerm" {
  subscription_id = "${var.azurerm_subscription_id}"
  client_id       = "${var.azurerm_client_id}"
  client_secret   = "${var.azurerm_client_secret}"
  tenant_id       = "${var.azurerm_tenant_id}"
}

resource "azurerm_resource_group" "resource_group" {
  name     = "${local.moniker}"
  location = "${var.azurerm_region}"
}
