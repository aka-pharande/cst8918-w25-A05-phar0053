# Configure the Terraform runtime requirements.
terraform {
  required_version = ">= 1.1.0"

  required_providers {
    # Azure Resource Manager provider and version
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.3"
    }
  }
}

# Define providers and their config params
provider "azurerm" {
  # Leave the features block empty to accept all defaults
  features {}
}

provider "cloudinit" {
  # Configuration options
}

# Define variables

variable "labelPrefix" {
  default = "myapp"
}

variable "region" {
  default = "East US"
}

variable "admin_username" {
  default = "azureuser"
}

# Creating Resource Group

resource "azurerm_resource_group" "rg" {
  name     = "${var.labelPrefix}-A05-RG"
  location = var.region
}

# Creating Public IP

resource "azurerm_public_ip" "public_ip" {
  name                = "${var.labelPrefix}-A05-PIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

# Creating a VNET

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.labelPrefix}-A05-VNet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

# Creating a Subnet

resource "azurerm_subnet" "subnet" {
  name                 = "${var.labelPrefix}-A05-Subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Creating a NSG


