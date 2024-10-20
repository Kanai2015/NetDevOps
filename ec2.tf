provider "aws" {
    alias  = "mumbai"
    region = "ap-south-1"
} 
provider "aws" {
    alias  = "sydney"
    region = "ap-southeast-2"
  }
provider "aws" {
    alias  = "london"
    region = "eu-west-2"
  }

# Security Groups
resource "aws_security_group" "allow_ssh_mumbai" {
  for_each = {
    mumbai_dev  = {vpcId=aws_vpc.mumbai_dev.id}
    mumbai_prod = {vpcId=aws_vpc.mumbai_prod.id}
  }

  name        = "allow_ssh_${each.key}"
  description = "Allow SSH inbound traffic"
  vpc_id      = each.value.vpcId
  provider    = aws.mumbai

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

}

resource "aws_security_group" "allow_ssh_sydney" {
  for_each = {
    sydney_dev  = {vpcId=aws_vpc.sydney_dev.id}
    sydney_prod = {vpcId=aws_vpc.sydney_prod.id}
  }

  name        = "allow_ssh_${each.key}"
  description = "Allow SSH inbound traffic"
  vpc_id      = each.value.vpcId
  provider    = aws.sydney

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

}

resource "aws_security_group" "allow_ssh_london" {
  for_each = {
     london_net  = {vpcId=aws_vpc.london_net.id}
  }

  name        = "allow_ssh_${each.key}"
  description = "Allow SSH inbound traffic"
  vpc_id      = each.value.vpcId
  provider    = aws.london

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

}

# EC2 Instances
data "aws_ami" "amazon_linux_2_mumbai" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
   provider = aws.mumbai

}

data "aws_ami" "amazon_linux_2_sydney" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
   provider = aws.sydney

}

data "aws_ami" "amazon_linux_2_london" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
   provider = aws.london

}

resource "aws_instance" "ec2_instances_mumbai" {
  for_each = {
    
    mumbai_dev  = { subnet = aws_subnet.mumbai_dev.id, sg = aws_security_group.allow_ssh_mumbai["mumbai_dev"].id }
    mumbai_prod = { subnet = aws_subnet.mumbai_prod.id, sg = aws_security_group.allow_ssh_mumbai["mumbai_prod"].id }
  }

  provider      = aws.mumbai
  ami           = data.aws_ami.amazon_linux_2_mumbai.id
  instance_type = "t2.micro"
  subnet_id     = each.value.subnet

  vpc_security_group_ids = [each.value.sg]

  tags = {
    Name = "EC2-${each.key}"
  }
}

resource "aws_instance" "ec2_instances_sydney" {
  for_each = {
    sydney_dev  = { subnet = aws_subnet.sydney_dev.id, sg = aws_security_group.allow_ssh_sydney["sydney_dev"].id }
    sydney_prod = { subnet = aws_subnet.sydney_prod.id, sg = aws_security_group.allow_ssh_sydney["sydney_prod"].id }
  }

  provider      = aws.sydney
  ami           = data.aws_ami.amazon_linux_2_sydney.id
  instance_type = "t2.micro"
  subnet_id     = each.value.subnet

  vpc_security_group_ids = [each.value.sg]

  tags = {
    Name = "EC2-${each.key}"
  }
}

resource "aws_instance" "ec2_instances_london" {
  for_each = {
    london_net  = { subnet = aws_subnet.london_net.id, sg = aws_security_group.allow_ssh_london["london_net"].id }
  }

  provider      = aws.london
  ami           = data.aws_ami.amazon_linux_2_london.id
  instance_type = "t2.micro"
  subnet_id     = each.value.subnet

  vpc_security_group_ids = [each.value.sg]

  tags = {
    Name = "EC2-${each.key}"
  }
}
