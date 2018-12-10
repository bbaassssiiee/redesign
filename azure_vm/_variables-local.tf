// NOTE: local variables can contain interpolations and allow for unifying certain variables
// NOTE: it is preferred to put all prefixed variables here and use them as `${local.name_of_var}`

locals {
  // NOTE: `moniker` looks something like `ac-wilbur-dev`
  moniker = "${var.organization}-${var.product}-${var.env}"

  // NOTE: `moniker_title` looks something like `AcWilburDev`
  moniker_title = "${title(var.organization)}${title(var.product)}${title(var.env)}"
}

locals {
  moniker_title_length = "${length(local.moniker_title)}"
}

locals {
  address_prefix        = "${var.address_prefix}"
  address_space         = ["${var.address_space}"]
  boot_diagnostics_name = "${lower("${local.moniker_title}${random_string.boot_diagnostics_name_suffix.result}")}"
  machine_identifier    = "${lower("${local.moniker_title}vm")}"
  network_name          = "${lower("${local.moniker_title}")}_net"
  security_group_name   = "${local.moniker}-secgrp"
  subnet_names          = "${formatlist("${local.moniker}-%s", var.subnet_names)}"

  tags {
    environment  = "${var.env}"
    organization = "${var.organization}"
    product      = "${var.product}"

    // TODO: add more default tags
  }
}

resource "random_string" "boot_diagnostics_name_suffix" {
  // NOTE: 24 is the max amount of characters that are permitted for use as a
  // NOTE Storage Account name. Since this name should be prefixed with the
  // NOTE: moniker, those characters have to be deducted from the total
  length = "${24 - local.moniker_title_length}"

  lower   = true
  number  = true
  special = false
  upper   = false
}
