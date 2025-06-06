output "aws_vpc_id" {
  description = "ID du VPC créé"
  value       = aws_vpc.main.id
}

output "aws_private_subnet_id" {
  description = "ID du subnet privé hébergeant les webservers"
  value       = aws_subnet.private.id
}

output "aws_igw_id" {
  description = "ID de l'Internet Gateway"
  value       = aws_internet_gateway.gw.id
}

output "aws_route_table_private_id" {
  description = "ID de la route table privée"
  value       = aws_route_table.private.id
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

output "web1_key_name" {
  description = "Nom de la key pair pour web1"
  value       = aws_instance.web1.key_name
}

output "web2_instance_id" {
  description = "ID de la seconde instance web"
  value       = aws_instance.web2.id
}

output "web2_private_ip" {
  description = "IP privée de la seconde instance web"
  value       = aws_instance.web2.private_ip
}

output "web2_key_name" {
  description = "Nom de la key pair pour web2"
  value       = aws_instance.web2.key_name
}
