data "http" "my_public_ip" {
  url = "http://checkip.amazonaws.com/"
}

locals {
  # Use chomp() to remove any trailing newlines or whitespace
  my_public_ip_cidr = "${chomp(data.http.my_public_ip.response_body)}/32"
}

## ------------------------------------------------------------------------------

# Application Security Groups (ASGs)
resource "azurerm_application_security_group" "nginx_asg" {
  name                = "nginx-asg"
  location            = var.region
  resource_group_name = var.resource_group_name
}

resource "azurerm_application_security_group" "app_asg" {
  name                = "app-asg"
  location            = var.region
  resource_group_name = var.resource_group_name
}

# Nginx SG
resource "azurerm_network_security_group" "nginx_sg" {
  name                = "nginx-sg"
  location            = var.region
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow-SSH-From-MyIP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = local.my_public_ip_cidr
    destination_address_prefix = "*"
  }

  # HTTP
  security_rule {
    name                       = "Allow-HTTP-All"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# ====================================================================

# Application SG
resource "azurerm_network_security_group" "app_sg" {
  name                = "app-sg"
  location            = var.region
  resource_group_name = var.resource_group_name

  # SSH 
  security_rule {
    name                       = "Allow-SSH-From-MyIP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = local.my_public_ip_cidr
    destination_address_prefix = "*"
  }

  # Allow HTTP traffic from Nginx ASG
  security_rule {
    name                                  = "Allow-8080-From-Nginx"
    priority                              = 110
    direction                             = "Inbound"
    access                                = "Allow"
    protocol                              = "Tcp"
    source_port_range                     = "*"
    destination_port_range                = "8080"
    source_application_security_group_ids = [azurerm_application_security_group.nginx_asg.id]
    destination_address_prefix            = "*"
  }
}

# ====================================================================

# Backend SG 
resource "azurerm_network_security_group" "backend_sg" {
  name                = "backend-sg"
  location            = var.region
  resource_group_name = var.resource_group_name

  # SSH
  security_rule {
    name                       = "Allow-SSH-From-MyIP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = local.my_public_ip_cidr
    destination_address_prefix = "*"
  }

  # Allow DB, Cache, and Message Broker traffic from App ASG
  security_rule {
    name                                  = "Allow-DB-Cache-From-App"
    priority                              = 110
    direction                             = "Inbound"
    access                                = "Allow"
    protocol                              = "Tcp"
    source_port_range                     = "*"
    destination_port_ranges               = ["3306", "11211", "5672"]
    source_application_security_group_ids = [azurerm_application_security_group.app_asg.id]
    destination_address_prefix            = "*"
  }
}