output "aws_vpc_id" {
  value = aws_vpc.main.id
}

output "aws_private_subnet_id" {
  value = aws_subnet.private.id
}

output "aws_igw_id" {
  value = aws_internet_gateway.gw.id
}

output "aws_route_table_private_id" {
  value = aws_route_table.private.id
}

output "web1_instance_id" {
  value = aws_instance.web1.id
}

output "web1_private_ip" {
  value = aws_instance.web1.private_ip
}

output "web1_key_name" {
  value = aws_instance.web1.key_name
}

output "web2_instance_id" {
  value = aws_instance.web2.id
}

output "web2_private_ip" {
  value = aws_instance.web2.private_ip
}

output "web2_key_name" {
  value = aws_instance.web2.key_name
}

output "webservers_sg_id" {
  value = aws_security_group.webservers_sg.id
}

# VPN-specific outputs
output "aws_customer_gateway_id" {
  value = aws_customer_gateway.cgw.id
}

output "aws_vpn_gateway_id" {
  value = aws_vpn_gateway.vgw.id
}

output "aws_vpn_connection_id" {
  value = aws_vpn_connection.vpn.id
}

output "aws_vpn_tunnel1_outside_address" {
  value = aws_vpn_connection.vpn.tunnel1_address
}

output "aws_vpn_tunnel2_outside_address" {
  value = aws_vpn_connection.vpn.tunnel2_address
}

output "aws_vpn_tunnel1_psk" {
  value     = aws_vpn_connection.vpn.tunnel1_preshared_key
  sensitive = true
}

output "aws_vpn_tunnel2_psk" {
  value     = aws_vpn_connection.vpn.tunnel2_preshared_key
  sensitive = true
}

output "aws_vpn_eip" {
  value = aws_eip.vpn.public_ip
}
