# Terraform settings, including the required providers Terraform will use to provision your infrastructure
terraform {
  required_providers {
    mysql = {
      source = "hashicorp/mysql"
    }
    # aws = {
    #   source = "hashicorp/aws"
    # }
  }
}
# Configure AWS provider
# provider "aws" {
#   shared_config_files      = ["~/.aws/config"]
#   shared_credentials_files = ["~/.aws/credentials"]
#   profile                  = "vscode"
#   region                   = "eu-central-1"
# }


# Configure the MySQL provider based on the outcome of
# creating the aws_db_instance.
# provider "mysql" {
#   endpoint = aws_db_instance.default.endpoint
#   username = aws_db_instance.default.username
#   password = aws_db_instance.default.password
# }
# Configure the MySQL provider
provider "mysql" {
  endpoint = "database-test-miro.example.com:3306"
  username = "app-user"
  password = "app-password"
}

