# # We need to have below resources for static web hosting
# # 1. S3 bucket
# # 2. CloudFront
# # 3. Route53


# create s3 bucket
resource "aws_s3_bucket" "static_web" {
  bucket        = local.s3_bucket_name_webapp
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "static_web" {
  bucket = aws_s3_bucket.static_web.id
  # access control list
  block_public_acls = true
  # reject new policy
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true


}
# protect data at rest
resource "aws_s3_bucket_server_side_encryption_configuration" "static_web" {
  bucket = aws_s3_bucket.static_web.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_s3_bucket_versioning" "static_web" {
  bucket = aws_s3_bucket.static_web.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_object" "web_content" {

  bucket                 = aws_s3_bucket.static_web.id
  key                    = local.key
  source                 = local.source
  server_side_encryption = "AES256"
  content_type           = "text/html"
}

resource "aws_cloudfront_origin_access_control" "site_access" {
  name                              = "site-access"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
resource "aws_cloudfront_distribution" "site_access" {
  enabled             = true
  default_root_object = local.key
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.static_web.id
    viewer_protocol_policy = "https-only"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }
  origin {
    domain_name              = aws_s3_bucket.static_web.bucket_domain_name
    origin_id                = aws_s3_bucket.static_web.id
    origin_access_control_id = aws_cloudfront_origin_access_control.site_access.id
  }
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["AT", "DE"]
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }


}
resource "aws_s3_bucket_policy" "site_policy" {
  bucket = aws_s3_bucket.static_web.id
  policy = data.aws_iam_policy_document.site_origin.json

}

# since this is exercise we will
# move local_webapp ->  s3  ->  ec2
# copy webapp data to s3 bucket
# resource "null_resource" "configure-s3-bucket-from-host" {
#   provisioner "local-exec" {
#     command     = "aws s3 cp ${local.webapp_dir_path} s3://${local.s3_bucket_name_webapp}/ --recursive"
#     interpreter = local.ec2_interpreter
#   }
#   depends_on = [aws_s3_bucket.apache_webserver_bucket]
# }


# # Create a VPC
# resource "aws_vpc" "app_vpc" {
#   cidr_block = local.vpc_cidr_block

#   tags = {
#     Name = local.vpc_tag_name
#   }
# }
# # Create a internet gateway for vpc
# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.app_vpc.id

#   tags = {
#     Name = local.igw_tag_name
#   }
# }

# # create subnet
# resource "aws_subnet" "public_subnet" {
#   vpc_id                  = aws_vpc.app_vpc.id
#   cidr_block              = local.subnet_public_cidr_block
#   map_public_ip_on_launch = true
#   availability_zone       = local.subnet_availability_zone

#   tags = {
#     Name = local.subnet_tag_name
#   }
# }
# # create route_table to be associated to subnet
# resource "aws_route_table" "public_rt" {
#   vpc_id = aws_vpc.app_vpc.id
#   # route can be separate resource or nested like here
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = {
#     Name = local.rt_tag_name
#   }
# }
# #create connection between route table and subnet
# resource "aws_route_table_association" "public_rt_asso" {
#   subnet_id      = aws_subnet.public_subnet.id
#   route_table_id = aws_route_table.public_rt.id
# }

# # create security group
# resource "aws_security_group" "webserver_sg" {
#   name        = local.sg_name
#   description = local.sg_description
#   vpc_id      = aws_vpc.app_vpc.id

#   ingress {
#     description = "HTTP"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "all from local pc"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["194.93.185.133/32"]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = {
#     Name = local.sg_tag_name
#   }
# }
# # need to create private & public key for key-pair
# # private key we need to store on local machine
# # public should be on the remote device
# resource "tls_private_key" "rsa_key" {
#   algorithm = "RSA"
#   rsa_bits  = 4096

# }
# # store private key local
# resource "local_file" "private_key" {
#   content  = tls_private_key.rsa_key.private_key_pem
#   filename = local.kp_private_key_file
# }
# # store public key local (not needed)
# resource "local_file" "public_key" {
#   content  = tls_private_key.rsa_key.public_key_pem
#   filename = local.kp_public_key_file
# }

# # needed to ssh into EC2 instance - this is aws resource
# # from which ec2 instance gets public key
# resource "aws_key_pair" "ubuntu_ssh_auth" {
#   key_name   = local.kp_name
#   public_key = tls_private_key.rsa_key.public_key_openssh

# }
# # change mode of the private key for ssh usage
# resource "null_resource" "configure-local-host" {
#   provisioner "local-exec" {
#     command     = "sudo chmod 400 ${local.kp_private_key_file}"
#     interpreter = local.ec2_interpreter

#   }
# }
# # EC2 instance definition
# resource "aws_instance" "webserver" {
#   ami                    = data.aws_ami.ec2_ubuntu.id
#   instance_type          = local.ec2_instance_type
#   key_name               = local.kp_name
#   subnet_id              = aws_subnet.public_subnet.id
#   vpc_security_group_ids = [aws_security_group.webserver_sg.id]
#   user_data              = file(local.ec2_user_data_file)

#   # instance profile is used to assign role to instance
#   iam_instance_profile = aws_iam_instance_profile.instance_profile.name
#   depends_on           = [aws_iam_instance_profile.instance_profile, null_resource.configure-s3-bucket-from-host]

#   # setting for local terminal, provisioner in not affecting state files !!
#   provisioner "local-exec" {
#     command = templatefile(local.ec2_template_file, {
#       hostname     = self.public_ip,
#       user         = local.ec2_user_name,
#       identityFile = local.kp_private_key_file
#     })
#     interpreter = local.ec2_interpreter
#   }


#   tags = {
#     Name = local.ec2_tag_name
#   }
# }

# # create s3 bucket
# resource "aws_s3_bucket" "apache_webserver_bucket" {
#   bucket        = local.s3_bucket_name_webapp
#   force_destroy = true
# }
# # since this is exercise we will
# # move local_webapp ->  s3  ->  ec2
# # copy webapp data to s3 bucket
# resource "null_resource" "configure-s3-bucket-from-host" {
#   provisioner "local-exec" {
#     command     = "aws s3 cp ${local.webapp_dir_path} s3://${local.s3_bucket_name_webapp}/ --recursive"
#     interpreter = local.ec2_interpreter
#   }
#   depends_on = [aws_s3_bucket.apache_webserver_bucket]
# }

# # give ec2 permission to read from s3
# resource "aws_iam_role" "ec2_iam_role" {
#   name               = local.ec2_role_name
#   assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
# }

# resource "aws_iam_role_policy" "join_policy" {
#   name = local.ec2_role_join_policy_name
#   # to which role
#   role = aws_iam_role.ec2_iam_role.name
#   # to attach which policy
#   policy = data.aws_iam_policy_document.s3_read_access.json
# }
# # instance profile is used to attach role to instance
# resource "aws_iam_instance_profile" "instance_profile" {
#   name = local.ec2_role_profile_name
#   role = aws_iam_role.ec2_iam_role.name
# }


