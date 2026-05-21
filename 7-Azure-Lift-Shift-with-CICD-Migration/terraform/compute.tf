# Nginx (Public Facing)
resource "azurerm_public_ip" "nginx_pip" {
  name                = "nginx-public-ip"
  location            = var.region
  resource_group_name = azurerm_resource_group.eprofile_rg.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nginx_nic" {
  name                = "nginx-nic"
  location            = var.region
  resource_group_name = azurerm_resource_group.eprofile_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.nginx_pip.id
  }
}

resource "azurerm_linux_virtual_machine" "nginx_vm" {
  name                = "nginx-vm"
  resource_group_name = azurerm_resource_group.eprofile_rg.name
  location            = var.region
  size                = var.vm_size
  admin_username      = "adminuser"

  network_interface_ids = [azurerm_network_interface.nginx_nic.id]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("${path.module}/azure_id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  # User Script
  custom_data = filebase64("../userdata-VMs/nginx.sh")
}

# ASG for Nginx
resource "azurerm_network_interface_application_security_group_association" "nginx_asg_link" {
  network_interface_id          = azurerm_network_interface.nginx_nic.id
  application_security_group_id = azurerm_application_security_group.nginx_asg.id
}

# =======================================================

# Application Server (Private)
resource "azurerm_network_interface" "app_nic" {
  name                = "app-nic"
  location            = var.region
  resource_group_name = azurerm_resource_group.eprofile_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet2.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "app_vm" {
  name                = "app-vm"
  resource_group_name = azurerm_resource_group.eprofile_rg.name
  location            = var.region
  size                = var.vm_size
  admin_username      = "adminuser"

  network_interface_ids = [azurerm_network_interface.app_nic.id]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("${path.module}/azure_id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  # User Script
  custom_data = filebase64("../userdata-VMs/tomcat_ubuntu.sh")

  # Managed Identity
  identity {
    type = "SystemAssigned"
  }
}

# ASG for App Server
resource "azurerm_network_interface_application_security_group_association" "app_asg_link" {
  network_interface_id          = azurerm_network_interface.app_nic.id
  application_security_group_id = azurerm_application_security_group.app_asg.id
}

# =======================================================

# Database Server (Private)

resource "azurerm_network_interface" "db_nic" {
  name                = "db-nic"
  location            = var.region
  resource_group_name = azurerm_resource_group.eprofile_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet3.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "db_vm" {
  name                = "db-vm"
  resource_group_name = azurerm_resource_group.eprofile_rg.name
  location            = var.region
  size                = var.vm_size
  admin_username      = "adminuser"

  network_interface_ids = [azurerm_network_interface.db_nic.id]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("${path.module}/azure_id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  # Managed Identity
  identity {
    type = "SystemAssigned"
  }

  # User Script
  custom_data = filebase64("../userdata-VMs/mysql.sh")
}

# =======================================================

# Memcached Server (Private)
resource "azurerm_network_interface" "memcached_nic" {
  name                = "memcached-nic"
  location            = var.region
  resource_group_name = azurerm_resource_group.eprofile_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet3.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "memcached_vm" {
  name                  = "memcached-vm"
  resource_group_name   = azurerm_resource_group.eprofile_rg.name
  location              = var.region
  size                  = var.vm_size
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.memcached_nic.id]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("${path.module}/azure_id_rsa.pub")
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  # User Script
  custom_data = filebase64("../userdata-VMs/memcache.sh")
}

# =======================================================

# RabbitMQ Server (Private)
resource "azurerm_network_interface" "rabbitmq_nic" {
  name                = "rabbitmq-nic"
  location            = var.region
  resource_group_name = azurerm_resource_group.eprofile_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet3.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "rabbitmq_vm" {
  name                  = "rabbitmq-vm"
  resource_group_name   = azurerm_resource_group.eprofile_rg.name
  location              = var.region
  size                  = var.vm_size
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.rabbitmq_nic.id]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("${path.module}/azure_id_rsa.pub")
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  # Managed Identity
  identity {
    type = "SystemAssigned"
  }

  # User Script
  custom_data = filebase64("../userdata-VMs/rabbitmq.sh")
}