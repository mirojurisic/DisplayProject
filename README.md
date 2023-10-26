# DisplayProject
Playing with cloud
# Idea
Planning to use IaC with terraform, deploy on Multicloud platforms, different project.
# Main terraform commands
```
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
terraform destroy
terraform console
terraform state list
terraform state show resource_name

```
ssh in to server
```
ssh user_name@public_ip_of_ec2 -i local_private_key_file

```
Apache2 webserver configuration
```
#!/bin/bash
apt-get update
apt-get install apache2 -y
cp /home/ubuntu/upload/index.html /var/www/html
chmod 644 /var/www/html/index.html
systemctl enable apache2
systemctl start apache2
```
## 1) Lambda with Terraform
Simple hello_world function that just prints text.
## 2) Apache on EC2 with Terraform
Download simple website, store it in S3 bucket, spin up EC2 instance using Terraform and deploy it with webapp code from S3 code

https://www.youtube.com/watch?v=cgTPxw2oGI8&list=PLRBkbp6t5gM2Lfbp2l-GGUM-jV7uOePlJ&index=7

https://medium.com/@somashekarvedadevops/deploy-apache-web-server-using-terraform-iac-276d51d90755

https://medium.com/aws-tip/run-aws-on-your-laptop-introduction-to-localstack-7269c19dedae
## 3) Trigger lambda from Apache
Connect one and two to log ip addresses from which the request was made.
Apache will trigger loambda and send IP.
