resource "azurerm_resource_group" "rg" {
  name     = "rg-core-resource"
  location = "northcentralus"
}

##################################
#Core VM configs
resource "azurerm_network_interface" "core_nic" {
  name                = "core-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "core_vm"
    subnet_id = var.core_internal_id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.0.254" #created Static IP for Linux server, Static due to you not wanting changes to servers. 
  }
}

resource "azurerm_virtual_machine" "Core_linux_vm" {
  name                  = "Linux-core-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.core_nic.id]
  vm_size = "Standard_D2s_v3"


storage_image_reference {
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-jammy"
  sku       = "22_04-lts"
  version   = "latest"
}
storage_os_disk {
  name              = "Core_storage_disk"
  caching           = "ReadWrite"
  create_option     = "FromImage"
  managed_disk_type = "Standard_LRS"
}
  os_profile {
    computer_name  = "corevm"
    admin_username = "coreadmin"
    admin_password = "1zqa2xws!ZQA@XWS"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

#########################################
#Spoke VM starts
resource "azurerm_network_interface" "Spoke_nic" {
  name                = "spoke-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "spoke_vm"
    subnet_id = var.spoke_internal_id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.1.254" #created static IP for Linux server, static due to you not wanting changes to servers. 
  }
}
resource "azurerm_virtual_machine" "spoke_linux_vm" {
  name                  = "Linux-spoke-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.Spoke_nic.id]
  vm_size = "Standard_D2s_v3"

storage_image_reference {
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-jammy"
  sku       = "22_04-lts"
  version   = "latest"
}
storage_os_disk {
  name              = "spoke_storage_disk"
  caching           = "ReadWrite"
  create_option     = "FromImage"
  managed_disk_type = "Standard_LRS"
}
  os_profile {
    computer_name  = "spokeuser"
    admin_username = "spokeadmin"
    admin_password = "1zqa2xws!ZQA@XWS"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}