
output "iam_jenkins_profile_name" {
  description = "IAM instance profile name used by Jenkins server"
  value       = aws_iam_instance_profile.jenkins_profile.name
}
