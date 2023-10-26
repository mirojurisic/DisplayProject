
output "web_instance_ip" {
  value = aws_instance.webserver.public_ip
}
output "ssh-command" {
  value = "ssh -i ${local.kp_private_key_file} ${local.ec2_user_name}@${aws_instance.webserver.public_ip}"
}
output "app_private_ip" {
  value = aws_instance.private_server.private_ip
}

# app_private_ip = "10.123.2.47"
# ssh-command = "v"
# web_instance_ip = "18.195.74.56"

# ssh -i /home/ubuntu/.ssh/ubuntu_kp_ssh ubuntu@10.123.2.47

# app_private_ip = "10.123.2.47"
# ssh-command = "ssh -i /home/mimo/.ssh/ubuntu_kp_ssh ubuntu@18.195.74.56"
# web_instance_ip = "18.195.74.56"
