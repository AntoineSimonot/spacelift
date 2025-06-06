# ────────────────────────────────────────────────────────────────────────────
# Outputs pour la stack AWS (à exposer vers la stack Azure)
# ────────────────────────────────────────────────────────────────────────────

output "aws_vpc_id" {
  description = "ID du VPC principal"
  value       = aws_vpc.main.id
}

output "aws_private_subnet_id" {
  description = "ID du sous-réseau privé hébergeant les EC2"
  value       = aws_subnet.private.id
}

output "webservers_sg_id" {
  description = "ID du Security Group des webservers"
  value       = aws_security_group.webservers_sg.id
}

output "web1_instance_id" {
  description = "ID de la première instance web"
  value       = aws_instance.web1.id
}

output "web1_private_ip" {
  description = "IP privée de la première instance web"
  value       = aws_instance.web1.private_ip
}

output "web2_instance_id" {
  description = "ID de la deuxième instance web"
  value       = aws_instance.web2.id
}

output "web2_private_ip" {
  description = "IP privée de la deuxième instance web"
  value       = aws_instance.web2.private_ip
}

# ────────────────────────────────────────────────────────────────────────────
# Outputs spécifiques au VPN AWS
# ────────────────────────────────────────────────────────────────────────────

output "aws_customer_gateway_id" {
  description = "ID du Customer Gateway (pointant vers Azure)"
  value       = aws_customer_gateway.cgw.id
}

output "aws_vpn_gateway_id" {
  description = "ID du VPN Gateway AWS"
  value       = aws_vpn_gateway.vgw.id
}

output "aws_vpn_connection_id" {
  description = "ID de la connexion VPN AWS"
  value       = aws_vpn_connection.vpn.id
}

output "aws_vpn_tunnel1_outside_address" {
  description = "IP publique Tunnel 1 AWS"
  value       = aws_vpn_connection.vpn.tunnel1_address
}

output "aws_vpn_tunnel2_outside_address" {
  description = "IP publique Tunnel 2 AWS"
  value       = aws_vpn_connection.vpn.tunnel2_address
}

output "aws_vpn_tunnel1_psk" {
  description = "PSK Tunnel 1 (sensible)"
  value       = aws_vpn_connection.vpn.tunnel1_preshared_key
  sensitive   = true
}

output "aws_vpn_tunnel2_psk" {
  description = "PSK Tunnel 2 (sensible)"
  value       = aws_vpn_connection.vpn.tunnel2_preshared_key
  sensitive   = true
}
