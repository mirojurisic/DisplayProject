output "web_instance_ip" {
  value = aws_instance.webserver.public_ip
}
output "ssh-command" {
  value = "ssh -i ${local.kp_private_key_file} ${local.ec2_user_name}@${aws_instance.webserver.public_ip}"
}
# aws s3 cp <your directory path> s3://<your bucket name> –recursive
# aws s3 cp ./webapp/ s3://miro-apache-simple-bucket/ --recursive
