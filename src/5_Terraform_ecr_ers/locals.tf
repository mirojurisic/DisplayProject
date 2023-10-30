locals {
  container_name   = "ExampleApacheContainer"
  ecs_cluster_name = "test_cluster"
  #vpc
  vpc_tag_name   = "ecs-subnet-vpc"
  vpc_cidr_block = "10.123.0.0/16"

  #subnet
  subnet_cidr_blocks       = ["10.123.1.0/24", "10.123.2.0/24"]
  subnet_availability_zone = "eu-central-1a"
  subnet_tag_names         = ["private-subnet1", "private-subnet2"]

  # ecs repo
  ecs_repo_name = "miro-test-repo"
}

# locals {

#   #igw
#   igw_tag_name = "vpc_igw"

#   #route_table1
#   rt_public_tag_name = "public-rt"
#   #route_table2
#   rt_private_tag_name = "private-rt"
#   #nat-gw
#   nat_gw_tag_name = "nat-gw"

#   #sg-default
#   sg_default_name = "default-sg"
#   sg_tag_name     = local.sg_default_name

#   #sg-for-ec2
#   sg_public_name        = "webserver-sg"
#   sg_public_description = "Allow HTTP and SSH inbound traffic"
#   sg_public_tag_name    = local.sg_public_name
#   #sg-for-private-ec2
#   sg_private_name        = "private-sg"
#   sg_private_description = "Allow SSH inbound traffic"
#   sg_private_tag_name    = local.sg_private_name
#   #key-pair-for-ec2
#   kp_name             = "ubuntu-kp-ssh"
#   kp_public_key_file  = "/home/mimo/.ssh/ubuntu_kp_ssh.pub"
#   kp_private_key_file = "/home/mimo/.ssh/ubuntu_kp_ssh"
#   #ec2
#   ec2_instance_type    = "t3.micro"
#   ec2_user_data_file   = "user_data.tpl"
#   ec2_tag_name         = "ec2_webserver"
#   ec2_private_tag_name = "ec2_private"
#   ec2_user_name        = "ubuntu"
#   ec2_template_file    = "linux-ssh-config.tpl"
#   ec2_interpreter      = ["bash", "-c"]
#   #ec2_ami
#   ec2_ami_filter_on     = "name"
#   ec2_ami_filter_values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
#   #   #ec2_role
#   #   ec2_role_name             = "ec2_iam_role_s3"
#   #   ec2_role_join_policy_name = "join_s3_policy"
#   #   ec2_role_profile_name     = "instance_profile"
#   #   #s3
#   #   s3_bucket_name_webapp = "miro-apache-simple-bucket"
#   #   #webapp
#   #   webapp_dir_path = "./webapp/"



#   #   # apache_webserver_bucket_name = "my-apache-webserver-bucket-sample"
# }
