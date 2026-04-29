
variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources"
}


variable "jenkins_server_ami_id" {
  type        = string
  description = "AMI ID for Jenkins server"
}


variable "jenkins_server_instance_type" {
  type        = string
  description = "EC2 instance type for Jenkins server"
}
