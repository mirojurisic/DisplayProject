# get authorization credentials to push to ecr
data "aws_ecr_authorization_token" "token" {}
