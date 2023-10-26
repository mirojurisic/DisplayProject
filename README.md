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
aws cli commands
```
aws s3 cp <your directory path> s3://<your bucket name> –recursive
```

## 1) Lambda with Terraform
Simple hello_world function that just prints text.
## 2) Apache on EC2 with Terraform
Download simple website, store it in S3 bucket, spin up EC2 instance using Terraform and deploy it with webapp code from S3 code

## 3) Private and public subnets with NAT
Connect one and two to log ip addresses from which the request was made.
Apache will trigger lambda and send IP.
