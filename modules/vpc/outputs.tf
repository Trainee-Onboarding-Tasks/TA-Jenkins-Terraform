
output "vpc_id" {
    description = "System VPC ID"
    value       = aws_vpc.system_vpc.id
}


output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [for subnet in aws_subnet.public_subnets : subnet.id]
}


output "public_subnet_cidrs" {
  description = "List of public subnet address"
  value       = [for subnet in aws_subnet.public_subnets : subnet.cidr_block]
}


output "private_server_subnet_ids" {
  description = "List of private llm servers subnet ids"
  value       = [for subnet in aws_subnet.private_servers_subnets : subnet.id]
}
