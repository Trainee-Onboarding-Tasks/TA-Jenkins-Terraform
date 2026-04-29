
resource "aws_instance" "jenkins_server" {
  ami                         = var.jenkins_server_ami_id
  instance_type               = var.jenkins_server_instance_type
  subnet_id                   = var.jenkins_server_subnet_id
  vpc_security_group_ids      = var.jenkins_server_sg_ids
  iam_instance_profile        = var.jenkins_instance_profile_name

  associate_public_ip_address = false

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = "Jenkins Server"
  }
}
