# 
# Create a VPC
resource "aws_vpc" "subnets_vpc" {
  cidr_block = local.vpc_cidr_block

  tags = {
    Name = local.vpc_tag_name
  }
}
# Create a internet gateway for vpc
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.subnets_vpc.id

  tags = {
    Name = local.igw_tag_name
  }
}

# create public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.subnets_vpc.id
  cidr_block              = local.subnet_public_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = local.subnet_public_availability_zone

  tags = {
    Name = local.subnet_public_tag_name
  }
}
# create private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.subnets_vpc.id
  cidr_block              = local.subnet_private_cidr_block
  map_public_ip_on_launch = false
  availability_zone       = local.subnet_public_availability_zone

  tags = {
    Name = local.subnet_private_tag_name
  }
}
# # create route_table to be associated to subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.subnets_vpc.id
  # route can be separate resource or nested like here
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = local.rt_public_tag_name
  }
}
# private route table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.subnets_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  depends_on = [aws_nat_gateway.nat]
  tags = {
    Name = local.rt_private_tag_name
  }
}
#create connection between route table and subnet
resource "aws_route_table_association" "public_rt_asso" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
#create connection between route table and subnet
resource "aws_route_table_association" "private_rt_asso" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}
#An Elastic IP address is a public IPv4 address, which is reachable from the internet
# create Elastic IP from nat
resource "aws_eip" "nat_eip" {
  depends_on = [aws_internet_gateway.igw]
}
# create nat gw for private subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name = local.nat_gw_tag_name
  }
}

# create security group
resource "aws_security_group" "public_sg" {
  name        = local.sg_public_name
  description = local.sg_public_description
  vpc_id      = aws_vpc.subnets_vpc.id

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
# create security group
resource "aws_security_group" "private_sg" {
  name        = local.sg_private_name
  description = local.sg_private_description
  vpc_id      = aws_vpc.subnets_vpc.id

  ingress {
    description     = "SSH"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
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
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  user_data              = file(local.ec2_user_data_file)

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
# EC2 instance definition
resource "aws_instance" "private_server" {
  ami                    = data.aws_ami.ec2_ubuntu.id
  instance_type          = local.ec2_instance_type
  key_name               = local.kp_name
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  user_data              = file(local.ec2_user_data_file)

  tags = {
    Name = local.ec2_private_tag_name
  }
}
