# To create VM(EC2) you need to choose AMI - amazon machine image
data "aws_ami" "ec2_ubuntu" {
  most_recent = true
  filter {
    name   = local.ec2_ami_filter_on
    values = local.ec2_ami_filter_values
  }

}
