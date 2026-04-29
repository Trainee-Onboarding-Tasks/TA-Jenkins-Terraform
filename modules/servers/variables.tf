
variable "jenkins_server_ami_id" {
  type        = string
  description = "AMI ID for Jenkins server"
}

variable "jenkins_server_instance_type" {
  type        = string
  description = "EC2 instance type for Jenkins server"
}

variable "jenkins_server_subnet_id" {
  type        = string
  description = "Subnet ID where Jenkins server will be deployed"
}

variable "jenkins_server_sg_ids" {
  type        = list(string)
  description = "List of security group IDs attached to Jenkins server"
}

variable "jenkins_instance_profile_name" {
  type        = string
  description = "IAM instance profile name for Jenkins server"
}
