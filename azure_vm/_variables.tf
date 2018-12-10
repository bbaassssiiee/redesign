// NOTE: mandatory variables, define them in terraform.tfvars

variable "azurerm_subscription_id" {
  type        = "string"
  description = "Azure subscription ID to use"
  default     = ""
}

variable "azurerm_client_id" {
  type        = "string"
  description = "Azure client ID to use"
  default     = ""
}

variable "azurerm_client_secret" {
  type        = "string"
  description = "Azure client secret to use"
  default     = ""
}

variable "azurerm_tenant_id" {
  type        = "string"
  description = "Azure tenant ID to use"
  default     = ""
}

// NOTE: sensible defaults, you can override these

variable "azurerm_region" {
  type        = "string"
  description = "Region, for more information see: https://azure.microsoft.com/en-us/regions/"
  default     = "westeurope"
}

variable "organization" {
  type        = "string"
  description = "prefix for all resources"
  default     = "bas"
}

variable "product" {
  type        = "string"
  description = "product for all resources"
  default     = "infra"
}

variable "env" {
  type        = "string"
  description = "environment for all resources"

  // NOTE: uses a value that should trigger folks
  default = "MISSING"
}

variable "admin_username" {
  type        = "string"
  description = "VM sudo user username"
  default     = "deploy"
}

variable "admin_password" {
  type        = "string"
  description = "admin user password"
  default     = ""
}

variable "ssh_key_path" {
  type        = "string"
  description = "Authorised key for SSH access"
  default     = "~/.ssh/id_rsa.pub"
}

variable "disk_os_size" {
  type        = "string"
  description = "system diskspace"
  default     = "30"
}

variable "image_uri" {
  description = "Specifies the image_uri in the form publisherName:offer:skus:version. image_uri can also specify the VHD uri of a custom VM image to clone."
}

variable "os_type" {
  description = "operating system: linux, or windows"
  default     = "linux"
}

variable "machine_size" {
  type        = "string"
  description = "machine_size defines costs"
  default     = "Basic_A0"
}

variable "machine_os_name" {
  type        = "string"
  description = "system diskspace"
  default     = "Centos"
}

variable "machine_os_version" {
  type        = "string"
  description = "system diskspace"
  default     = "7.3"
}

variable "machine_os_publisher" {
  type        = "string"
  description = "OS publisher"
  default     = "OpenLogic"
}

variable "machine_os_product" {
  type        = "string"
  description = "Offer"
  default     = "CentOS"
}

variable "machine_count" {
  type        = "string"
  description = "number of machines"
  default     = "0"
}

variable "disk_data_type" {
  type        = "string"
  description = "database diskspace"
  default     = "Standard_LRS"
}

variable "disk_os_type" {
  type        = "string"
  description = "filesystem format"
  default     = ""
}

variable "disk_data_size" {
  type        = "string"
  description = "data diskspace"
  default     = "50"
}

variable "address_space" {
  type        = "string"
  description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
  default     = "10.0.0.0/24"
}

variable "address_prefix" {
  description = "The address prefix to use for the subnet."
  default     = "10.0.0.0/24"
}

variable "network_interface_ipconfiguration_name" {
  type        = "string"
  description = "network config"

  // NOTE: can be up to 80 characters long.
  // It must begin with a word character,
  // and it must end with a word character or with '_'.
  // The name may contain word characters or '.', '-', '_'.
  default = ""
}

variable "private_ip_address_allocation" {
  type        = "string"
  description = "internal ip address allocation"
  default     = "Dynamic"
}

variable "public_ip_address_allocation" {
  type        = "string"
  description = "external ip address"
  default     = "Dynamic"
}

variable "dns_servers" {
  type        = "list"
  description = "internet domain name servers"
  default     = ["8.8.8.8", "8.8.4.4"]
}

variable "subnet_names" {
  type        = "list"
  description = "subnet names"
  default     = ["subnet"]
}

variable "allow_inbound_https" {
  default = true
}

variable "allow_inbound_ssh" {
  default = true
}

variable "ip_whitelist_inbound_ssh" {
  type    = "string"
  default = "0.0.0.0"
}

variable "ip_whitelist_inbound_https" {
  type    = "string"
  default = "0.0.0.0"
}
