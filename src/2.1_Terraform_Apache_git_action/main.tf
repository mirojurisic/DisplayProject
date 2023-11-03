# We need to have below resources for creating an EC2 instance
# VPC
# Internet Gateway
# Subnet - Public
# Route table
# Route table association to subnet
# Security Group
# key-pair
# EC2 instance definition - AMI, Instance type, Key pair, Subnet ID, Security group ID
# S3 bucket to hold webapp files

# Create a VPC
resource "aws_vpc" "app_vpc" {
  cidr_block = local.vpc_cidr_block

  tags = {
    Name = local.vpc_tag_name
  }
}
# Create a internet gateway for vpc
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = local.igw_tag_name
  }
}

# create subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = local.subnet_public_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = local.subnet_availability_zone

  tags = {
    Name = local.subnet_tag_name
  }
}
# create route_table to be associated to subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.app_vpc.id
  # route can be separate resource or nested like here
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = local.rt_tag_name
  }
}
#create connection between route table and subnet
resource "aws_route_table_association" "public_rt_asso" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# create security group
resource "aws_security_group" "webserver_sg" {
  name        = local.sg_name
  description = local.sg_description
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "all from local pc"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["194.93.185.133/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = local.sg_tag_name
  }
}
# need to create private & public key for key-pair
# private key we need to store on local machine
# public should be on the remote device
resource "tls_private_key" "rsa_key" {
  algorithm = "RSA"
  rsa_bits  = 4096

}
# store private key local
resource "local_file" "private_key" {
  content  = tls_private_key.rsa_key.private_key_pem
  filename = local.kp_private_key_file
}
# store public key local (not needed)
resource "local_file" "public_key" {
  content  = tls_private_key.rsa_key.public_key_pem
  filename = local.kp_public_key_file
}

# needed to ssh into EC2 instance - this is aws resource
# from which ec2 instance gets public key
resource "aws_key_pair" "ubuntu_ssh_auth" {
  key_name   = local.kp_name
  public_key = tls_private_key.rsa_key.public_key_openssh

}
# change mode of the private key for ssh usage
resource "null_resource" "configure-local-host" {
  provisioner "local-exec" {
    command     = "sudo chmod 400 ${local.kp_private_key_file}"
    interpreter = local.ec2_interpreter

  }
}
# EC2 instance definition
resource "aws_instance" "webserver" {
  ami                    = data.aws_ami.ec2_ubuntu.id
  instance_type          = local.ec2_instance_type
  key_name               = local.kp_name
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  user_data              = file(local.ec2_user_data_file)

  # instance profile is used to assign role to instance
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  depends_on           = [aws_iam_instance_profile.instance_profile, null_resource.configure-s3-bucket-from-host]

  # setting for local terminal, provisioner in not affecting state files !!
  provisioner "local-exec" {
    command = templatefile(local.ec2_template_file, {
      hostname     = self.public_ip,
      user         = local.ec2_user_name,
      identityFile = local.kp_private_key_file
    })
    interpreter = local.ec2_interpreter
  }


  tags = {
    Name = local.ec2_tag_name
  }
}
