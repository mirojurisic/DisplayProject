# To create VM(EC2) you need to choose AMI - amazon machine image
data "aws_ami" "ec2_ubuntu" {
  most_recent = true
  filter {
    name   = local.ec2_ami_filter_on
    values = local.ec2_ami_filter_values
  }

}
# data "aws_iam_policy_document" "ec2_assume_role" {
#   statement {
#     actions = ["sts:AssumeRole"]

#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }
#   }
# }

# data "aws_iam_policy_document" "s3_read_access" {
#   statement {
#     actions = ["s3:Get*", "s3:List*"]

#     resources = ["arn:aws:s3:::*"]
#   }
# }
