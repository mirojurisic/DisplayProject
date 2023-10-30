# Terraform settings, including the required providers Terraform will use to provision your infrastructure
terraform {
  required_providers {
    docker = {
      # the source attribute defines an optional hostname, a namespace, and the provider type.
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
}


# configure docker provider
provider "docker" {
  registry_auth {
    address  = data.aws_ecr_authorization_token.token.proxy_endpoint
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}
provider "aws" {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "vscode"
  region                   = "eu-central-1"
}
