resource "azurerm_storage_account" "storage_account" {
  account_kind              = "Storage"
  account_replication_type  = "LRS"
  account_tier              = "Standard"
  enable_https_traffic_only = true
  location                  = "${azurerm_resource_group.resource_group.location}"
  name                      = "${lower("${local.moniker_title}")}"
  resource_group_name       = "${azurerm_resource_group.resource_group.name}"
  tags                      = "${local.tags}"
}

resource "azurerm_storage_container" "disk_images" {
  container_access_type = "private"
  name                  = "images"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  storage_account_name  = "${azurerm_storage_account.storage_account.name}"
}
