resource "azurerm_virtual_network" "network" {
  address_space       = ["${var.address_space}"]
  dns_servers         = "${var.dns_servers}"
  location            = "${azurerm_resource_group.resource_group.location}"
  name                = "${local.network_name}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  tags                = "${local.tags}"
}

resource "azurerm_subnet" "subnet" {
  address_prefix            = "${var.address_prefix}"
  count                     = "${length(var.subnet_names)}"
  name                      = "${local.subnet_names[count.index]}"
  network_security_group_id = "${azurerm_network_security_group.security_group.id}"
  resource_group_name       = "${azurerm_resource_group.resource_group.name}"
  virtual_network_name      = "${azurerm_virtual_network.network.name}"
}

resource "azurerm_network_security_group" "security_group" {
  location            = "${azurerm_resource_group.resource_group.location}"
  name                = "${local.security_group_name}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
}

resource "azurerm_network_security_rule" "security_rule_ssh" {
  access                      = "Allow"
  count                       = "${var.allow_inbound_ssh ? 1 : 0 }"
  description                 = "SSH Rule for ${local.moniker}"
  destination_address_prefix  = "*"
  destination_port_range      = "22"
  direction                   = "Inbound"
  name                        = "${local.moniker}-ssh"
  network_security_group_name = "${azurerm_network_security_group.security_group.name}"
  priority                    = 101
  protocol                    = "Tcp"
  resource_group_name         = "${azurerm_resource_group.resource_group.name}"
  source_address_prefix       = "${var.ip_whitelist_inbound_ssh}"
  source_port_range           = "*"
}

resource "azurerm_network_security_rule" "security_rule_https" {
  access                      = "Allow"
  count                       = "${var.allow_inbound_https ? 1 : 0 }"
  description                 = "HTTPs Rule for ${local.moniker}"
  destination_address_prefix  = "*"
  destination_port_range      = "443"
  direction                   = "Inbound"
  name                        = "${local.moniker}-https"
  network_security_group_name = "${azurerm_network_security_group.security_group.name}"
  priority                    = 102
  protocol                    = "Tcp"
  resource_group_name         = "${azurerm_resource_group.resource_group.name}"
  source_address_prefix       = "${var.ip_whitelist_inbound_https}"
  source_port_range           = "*"
}

resource "azurerm_public_ip" "public_ip" {
  count                        = "${var.machine_count}"
  domain_name_label            = "${local.machine_identifier}-${count.index}"
  location                     = "${var.azurerm_region}"
  name                         = "${local.machine_identifier}-${count.index + 1}-public-ip"
  public_ip_address_allocation = "${var.public_ip_address_allocation}"
  resource_group_name          = "${azurerm_resource_group.resource_group.name}"
}

resource "azurerm_network_interface" "network_interface" {
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "${lower("${local.moniker_title}")}_ipconfig"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "${var.private_ip_address_allocation}"
    public_ip_address_id          = "${length(azurerm_public_ip.public_ip.*.id) > 0 ? element(concat(azurerm_public_ip.public_ip.*.id, list("")), count.index) : ""}"
    primary                       = "true"
  }

  location                  = "${azurerm_resource_group.resource_group.location}"
  name                      = "${lower("${local.moniker_title}")}_nic"
  network_security_group_id = "${azurerm_network_security_group.security_group.id}"
  resource_group_name       = "${azurerm_resource_group.resource_group.name}"
  tags                      = "${local.tags}"
}
