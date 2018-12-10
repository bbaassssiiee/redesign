//resource "azurerm_availability_set" "availability_set" {
//  name                = "${local.machine_identifier}-set"
//  location            = "${azurerm_resource_group.resource_group.location}"
//  resource_group_name = "${azurerm_resource_group.resource_group.name}"
//
//  tags = "${local.tags}"
//}

resource "azurerm_managed_disk" "osdisk" {
  name                 = "${local.moniker}-osdisk"
  location             = "${azurerm_resource_group.resource_group.location}"
  resource_group_name  = "${azurerm_resource_group.resource_group.name}"
  storage_account_type = "Standard_LRS"

  os_type       = "Linux"
  create_option = "Import"
  source_uri    = "https://mystorage.blob.core.windows.net/system/Microsoft.Compute/Images/images/packer-osDisk.850f2a37-a2eb-491e-ab8c-0f8282b4f97e.vhd"
  disk_size_gb  = "31"
}

resource "azurerm_virtual_machine" "virtual_machine" {
  count                 = "${var.machine_count}"
  name                  = "${local.machine_identifier}-${count.index + 1}"
  location              = "${azurerm_resource_group.resource_group.location}"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  vm_size               = "${var.machine_size}"
  network_interface_ids = ["${element(azurerm_network_interface.network_interface.*.id, count.index)}"]

  storage_os_disk {
    name          = "${local.machine_identifier}-osdisk1"
    image_uri     = "https://mystorage.blob.core.windows.net/system/Microsoft.Compute/Images/images/packer-osDisk.850f2a37-a2eb-491e-ab8c-0f8282b4f97e.vhd"
    vhd_uri       = "https://${azurerm_storage_account.storage_account.name}.blob.core.windows.net/vhds/${local.machine_identifier}-osdisk.vhd"
    os_type       = "Linux"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  // storage_os_disk {
  //   name = "${azurerm_managed_disk.osdisk.name}-osdisk"
  //
  //   # if this is provided, os_profile is not allowed
  //   // os_type           = "Linux"
  //   managed_disk_id   = "${azurerm_managed_disk.osdisk.id}"
  //   managed_disk_type = "Standard_LRS"
  //   caching           = "ReadWrite"
  //   create_option     = "Attach"
  // }

  storage_data_disk {
    name              = "${azurerm_managed_disk.datadisk.name}"
    managed_disk_id   = "${azurerm_managed_disk.datadisk.id}"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = "31"
    create_option     = "Attach"
    lun               = 0
  }
  boot_diagnostics {
    enabled     = false
    storage_uri = ""
  }
  delete_os_disk_on_termination = true
  os_profile {
    admin_password = "${var.admin_password}"
    admin_username = "${var.admin_username}"
    computer_name  = "${local.machine_identifier}vm${count.index + 1}"
  }
  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      key_data = "${file("${var.ssh_key_path}")}"
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
    }
  }
  // NOTE: Addition of a managed disk to a VM with blob based disks is not supported
  //  delete_data_disks_on_termination = false
  //  storage_data_disk {
  //    create_option       = "Empty"
  //    disk_size_gb        = "${var.disk_data_size}"
  //    lun                 = 0
  //    managed_disk_type   = "${var.disk_data_type}"
  //    name                = "${local.machine_identifier}-${count.index + 1}-disk-data"
  //  }
  tags = "${local.tags}"
}

resource "azurerm_managed_disk" "datadisk" {
  name                 = "${local.moniker}-datadisk"
  location             = "${azurerm_resource_group.resource_group.location}"
  resource_group_name  = "${azurerm_resource_group.resource_group.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "31"
}
