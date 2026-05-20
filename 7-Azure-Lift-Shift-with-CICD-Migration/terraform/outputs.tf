output "nginx_public_ip" {
  description = "The Public IP address of the Nginx Reverse Proxy (Frontend)"
  value       = azurerm_public_ip.nginx_pip.ip_address
}
