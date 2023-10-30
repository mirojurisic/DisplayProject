# Create a VPC
resource "aws_vpc" "ecs_vpc" {
  cidr_block = local.vpc_cidr_block

  tags = {
    Name = local.vpc_tag_name
  }
}
# create private subnet
resource "aws_subnet" "private_subnet" {
  count      = length(local.subnet_cidr_blocks)
  vpc_id     = aws_vpc.ecs_vpc.id
  cidr_block = local.subnet_cidr_blocks[count.index]

  map_public_ip_on_launch = true
  availability_zone       = local.subnet_availability_zone

  tags = {
    Name = local.subnet_tag_names[count.index]
  }
}
resource "aws_ecr_repository" "miro_repo_docker" {
  name = local.ecs_repo_name


  image_scanning_configuration {
    scan_on_push = true
  }
}
# build docker image
resource "docker_image" "my-docker-image" {
  name = "${data.aws_ecr_authorization_token.token.proxy_endpoint}/${local.ecs_repo_name}:latest"
  build {
    context = "."
  }
  platform = "linux/arm64"
}

# push image to ecr repo
resource "docker_registry_image" "media-handler" {
  name = docker_image.my-docker-image.name
}

resource "docker_image" "ubuntu_apache" {
  name         = "ubuntu/apache2:edge"
  keep_locally = true
}



# resource "docker_container" "apache_container" {
#   image = docker_image.ubuntu_apache.image_id
#   name  = locals.container_name
#   ports {
#     internal = 80
#     external = 8000
#   }
#   volumes {
#     host_path      = "./webapp/public-html" # Replace with the path to your local files
#     container_path = "/var/www/html/"       # Replace with the path inside the container
#   }
# }

