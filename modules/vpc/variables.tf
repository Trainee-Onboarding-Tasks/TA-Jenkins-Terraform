
variable "cidr" {
  type        = string
  description = "Cidr block address for VPC"
}


variable "available_zones_list" {
  type        = list(string)
  description = "List of availability zones in region"
}


variable "public_subnets" {
  type        = list(string)
  description = "Cidr block list of public subnets"
}


variable "private_servers_subnets" {
  type        = list(string)
  description = "Cidr block list of private servers subnets"
}
