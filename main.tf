
terraform {
  required_version = ">=1.5.0"

  backend "s3" {
    bucket   = "trainee-onboarding-tasks"
    key      = "jenkins/state"
    region   = "us-east-1"
    encrypt  = true
  }
}


provider "aws" {
  region = var.aws_region
}


module "vpc" {
  source = "./modules/vpc"

  cidr = "10.0.0.0/16"   

  available_zones_list = [
    "us-east-1a"
  ]

  public_subnets = [
    "10.0.1.0/24"        
  ]

  private_servers_subnets = [
    "10.0.2.0/24"        
  ]
}


module "sg" {
  source          = "./modules/sg"
  vpc_id          = module.vpc.vpc_id

  security_groups = {

    jenkins_server_sg = {
      ingress_ports_tcp       = []
      ingress_ports_udp       = []
      allowed_cidr_blocks     = []
      allowed_security_groups = []
    }
  }
}


module "iam" {
  source = "./modules/iam"
}


module "servers" {
  source                            = "./modules/servers"
  
  jenkins_server_ami_id             = var.jenkins_server_ami_id
  jenkins_server_instance_type      = var.jenkins_server_instance_type
  jenkins_server_subnet_id          = module.vpc.private_server_subnet_ids[0]
  jenkins_server_sg_ids             = [module.sg.security_group_ids["jenkins_server_sg"]]
  jenkins_instance_profile_name     = module.iam.iam_jenkins_profile_name
}
