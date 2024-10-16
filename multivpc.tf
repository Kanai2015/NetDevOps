# Mumbai VPCs
resource "aws_vpc" "mumbai_dev" {
  provider             = aws.mumbai
  cidr_block           = var.vpc_cidr_blocks["mumbai_dev"]
  enable_dns_hostnames = true
  tags = {
    Name = "Mumbai-Dev-VPC"
  }
}

resource "aws_vpc" "mumbai_prod" {
  provider             = aws.mumbai
  cidr_block           = var.vpc_cidr_blocks["mumbai_prod"]
  enable_dns_hostnames = true
  tags = {
    Name = "Mumbai-Prod-VPC"
  }
}

# Sydney VPCs
resource "aws_vpc" "sydney_dev" {
  provider             = aws.sydney
  cidr_block           = var.vpc_cidr_blocks["sydney_dev"]
  enable_dns_hostnames = true
  tags = {
    Name = "Sydney-Dev-VPC"
  }
}

resource "aws_vpc" "sydney_prod" {
  provider             = aws.sydney
  cidr_block           = var.vpc_cidr_blocks["sydney_prod"]
  enable_dns_hostnames = true
  tags = {
    Name = "Sydney-Prod-VPC"
  }
}

# London Networking VPC
resource "aws_vpc" "london_net" {
  provider             = aws.london
  cidr_block           = var.vpc_cidr_blocks["london_net"]
  enable_dns_hostnames = true
  tags = {
    Name = "London-Networking-VPC"
  }
}

# Subnets
resource "aws_subnet" "mumbai_dev" {
  provider          = aws.mumbai
  vpc_id            = aws_vpc.mumbai_dev.id
  cidr_block        = var.subnet_cidr_blocks["mumbai_dev"]
  availability_zone = "ap-south-1a"
  tags = {
    Name = "Mumbai-Dev-Subnet"
  }
}

resource "aws_subnet" "mumbai_prod" {
  provider          = aws.mumbai
  vpc_id            = aws_vpc.mumbai_prod.id
  cidr_block        = var.subnet_cidr_blocks["mumbai_prod"]
  availability_zone = "ap-south-1b"
  tags = {
    Name = "Mumbai-Prod-Subnet"
  }
}

resource "aws_subnet" "sydney_dev" {
  provider          = aws.sydney
  vpc_id            = aws_vpc.sydney_dev.id
  cidr_block        = var.subnet_cidr_blocks["sydney_dev"]
  availability_zone = "ap-southeast-2a"
  tags = {
    Name = "Sydney-Dev-Subnet"
  }
}

resource "aws_subnet" "sydney_prod" {
  provider          = aws.sydney
  vpc_id            = aws_vpc.sydney_prod.id
  cidr_block        = var.subnet_cidr_blocks["sydney_prod"]
  availability_zone = "ap-southeast-2b"
  tags = {
    Name = "Sydney-Prod-Subnet"
  }
}

resource "aws_subnet" "london_net" {
  provider          = aws.london
  vpc_id            = aws_vpc.london_net.id
  cidr_block        = var.subnet_cidr_blocks["london_net"]
  availability_zone = "eu-west-2a"
  tags = {
    Name = "London-Networking-Subnet"
  }
}

# Internet Gateways
resource "aws_internet_gateway" "mumbai_dev" {
  provider = aws.mumbai
  vpc_id   = aws_vpc.mumbai_dev.id
  tags = {
    Name = "Mumbai-Dev-IGW"
  }
}

resource "aws_internet_gateway" "mumbai_prod" {
  provider = aws.mumbai
  vpc_id   = aws_vpc.mumbai_prod.id
  tags = {
    Name = "Mumbai-Prod-IGW"
  }
}

resource "aws_internet_gateway" "sydney_dev" {
  provider = aws.sydney
  vpc_id   = aws_vpc.sydney_dev.id
  tags = {
    Name = "Sydney-Dev-IGW"
  }
}

resource "aws_internet_gateway" "sydney_prod" {
  provider = aws.sydney
  vpc_id   = aws_vpc.sydney_prod.id
  tags = {
    Name = "Sydney-Prod-IGW"
  }
}

resource "aws_internet_gateway" "london_net" {
  provider = aws.london
  vpc_id   = aws_vpc.london_net.id
  tags = {
    Name = "London-Networking-IGW"
  }
}

# Route Tables
resource "aws_route_table" "mumbai_dev" {
  provider = aws.mumbai
  vpc_id   = aws_vpc.mumbai_dev.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mumbai_dev.id
  }
  tags = {
    Name = "Mumbai-Dev-RT"
  }
}

resource "aws_route_table" "mumbai_prod" {
  provider = aws.mumbai
  vpc_id   = aws_vpc.mumbai_prod.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mumbai_prod.id
  }
  tags = {
    Name = "Mumbai-Prod-RT"
  }
}

resource "aws_route_table" "sydney_dev" {
  provider = aws.sydney
  vpc_id   = aws_vpc.sydney_dev.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sydney_dev.id
  }
  tags = {
    Name = "Sydney-Dev-RT"
  }
}

resource "aws_route_table" "sydney_prod" {
  provider = aws.sydney
  vpc_id   = aws_vpc.sydney_prod.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sydney_prod.id
  }
  tags = {
    Name = "Sydney-Prod-RT"
  }
}

resource "aws_route_table" "london_net" {
  provider = aws.london
  vpc_id   = aws_vpc.london_net.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.london_net.id
  }
  tags = {
    Name = "London-Networking-RT"
  }
}

# Route Table Associations
resource "aws_route_table_association" "mumbai_dev" {
  provider       = aws.mumbai
  subnet_id      = aws_subnet.mumbai_dev.id
  route_table_id = aws_route_table.mumbai_dev.id
}

resource "aws_route_table_association" "mumbai_prod" {
  provider       = aws.mumbai
  subnet_id      = aws_subnet.mumbai_prod.id
  route_table_id = aws_route_table.mumbai_prod.id
}

resource "aws_route_table_association" "sydney_dev" {
  provider       = aws.sydney
  subnet_id      = aws_subnet.sydney_dev.id
  route_table_id = aws_route_table.sydney_dev.id
}

resource "aws_route_table_association" "sydney_prod" {
  provider       = aws.sydney
  subnet_id      = aws_subnet.sydney_prod.id
  route_table_id = aws_route_table.sydney_prod.id
}

resource "aws_route_table_association" "london_net" {
  provider       = aws.london
  subnet_id      = aws_subnet.london_net.id
  route_table_id = aws_route_table.london_net.id
}

# Security Groups
resource "aws_security_group" "allow_ssh" {
  for_each = {
    mumbai_dev  = aws_vpc.mumbai_dev.id
    mumbai_prod = aws_vpc.mumbai_prod.id
    sydney_dev  = aws_vpc.sydney_dev.id
    sydney_prod = aws_vpc.sydney_prod.id
    london_net  = aws_vpc.london_net.id
  }

  name        = "allow_ssh_${each.key}"
  description = "Allow SSH inbound traffic"
  vpc_id      = each.value

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow-SSH-${each.key}"
  }

#   provider = each.key == "london_net" ? aws.london : (
#     contains(["sydney_dev", "sydney_prod"], each.key) ? aws.sydney : aws.mumbai
#   )
}

# EC2 Instances
data "aws_ami" "amazon_linux_2" {
  for_each = toset(["mumbai", "sydney", "london"])

  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

#   provider = each.key == "london" ? aws.london : (
#     each.key == "sydney" ? aws.sydney : aws.mumbai
#   )
}

resource "aws_instance" "ec2_instances" {
  for_each = {
    mumbai_dev  = { provider = aws.mumbai, subnet = aws_subnet.mumbai_dev.id, sg = aws_security_group.allow_ssh["mumbai_dev"].id }
    mumbai_prod = { provider = aws.mumbai, subnet = aws_subnet.mumbai_prod.id, sg = aws_security_group.allow_ssh["mumbai_prod"].id }
    sydney_dev  = { provider = aws.sydney, subnet = aws_subnet.sydney_dev.id, sg = aws_security_group.allow_ssh["sydney_dev"].id }
    sydney_prod = { provider = aws.sydney, subnet = aws_subnet.sydney_prod.id, sg = aws_security_group.allow_ssh["sydney_prod"].id }
    london_net  = { provider = aws.london, subnet = aws_subnet.london_net.id, sg = aws_security_group.allow_ssh["london_net"].id }
  }

#   provider      = each.value.provider
  ami           = data.aws_ami.amazon_linux_2[split("_", each.key)[0]].id
  instance_type = "t2.micro"
  subnet_id     = each.value.subnet

  vpc_security_group_ids = [each.value.sg]

  tags = {
    Name = "EC2-${each.key}"
  }
}
