
variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}


variable "jenkins_server_ami_id" {
  type        = string
  description = "AMI ID for Jenkins server"
  default     = "ami-02aeb3c8edb7fcc8d"
}


variable "jenkins_server_instance_type" {
  type        = string
  description = "EC2 instance type for Jenkins server"
  default     = "t3.medium"
}
