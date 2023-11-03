output "web_instance_ip" {
  value = aws_instance.webserver.public_ip
}
output "ssh-command" {
  value = "ssh -i ${local.kp_private_key_file} ${local.ec2_user_name}@${aws_instance.webserver.public_ip}"
}
