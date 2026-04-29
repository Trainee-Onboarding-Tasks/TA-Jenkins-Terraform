
output "jenkins_instance_id" {
  value       = aws_instance.jenkins_server.id
  description = "Jenkins server instance ID"
}
