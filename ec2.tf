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
resource "aws_security_group" "allow_ssh" {
  for_each = {
    mumbai_dev  = {vpcId=aws_vpc.mumbai_dev.id,pro=".mumbai"}
    mumbai_prod = {vpcId=aws_vpc.mumbai_prod.id,pro=".mumbai"}
    sydney_dev  = {vpcId=aws_vpc.sydney_dev.id,pro=".sydney"}
    sydney_prod = {vpcId=aws_vpc.sydney_prod.id,pro=".sydney"}
    london_net  = {vpcId=aws_vpc.london_net.id,pro=".london"}
  }

  name        = "allow_ssh_${each.key}"
  description = "Allow SSH inbound traffic"
  vpc_id      = each.value.vpcId
  # provider    = "aws.${each.value.pro}"
  provider    = aws[each.value.pro]

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

# # EC2 Instances
# data "aws_ami" "amazon_linux_2" {
#   for_each = toset(["mumbai", "sydney", "london"])

#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm-*-x86_64-gp2"]
#   }

# #   provider = each.key == "london" ? aws.london : (
# #     each.key == "sydney" ? aws.sydney : aws.mumbai
# #   )
# }

# resource "aws_instance" "ec2_instances" {
#   for_each = {
#     # mumbai_dev  = { provider = aws.mumbai, subnet = aws_subnet.mumbai_dev.id, sg = aws_security_group.allow_ssh["mumbai_dev"].id }
#     # mumbai_prod = { provider = aws.mumbai, subnet = aws_subnet.mumbai_prod.id, sg = aws_security_group.allow_ssh["mumbai_prod"].id }
#     # sydney_dev  = { provider = aws.sydney, subnet = aws_subnet.sydney_dev.id, sg = aws_security_group.allow_ssh["sydney_dev"].id }
#     # sydney_prod = { provider = aws.sydney, subnet = aws_subnet.sydney_prod.id, sg = aws_security_group.allow_ssh["sydney_prod"].id }
#     # london_net  = { provider = aws.london, subnet = aws_subnet.london_net.id, sg = aws_security_group.allow_ssh["london_net"].id }
#     mumbai_dev  = { subnet = aws_subnet.mumbai_dev.id, sg = aws_security_group.allow_ssh["mumbai_dev"].id }
#     mumbai_prod = { subnet = aws_subnet.mumbai_prod.id, sg = aws_security_group.allow_ssh["mumbai_prod"].id }
#     sydney_dev  = { subnet = aws_subnet.sydney_dev.id, sg = aws_security_group.allow_ssh["sydney_dev"].id }
#     sydney_prod = { subnet = aws_subnet.sydney_prod.id, sg = aws_security_group.allow_ssh["sydney_prod"].id }
#     london_net  = { subnet = aws_subnet.london_net.id, sg = aws_security_group.allow_ssh["london_net"].id }
#   }

# #   provider      = each.value.provider
#   ami           = data.aws_ami.amazon_linux_2[split("_", each.key)[0]].id
#   instance_type = "t2.micro"
#   subnet_id     = each.value.subnet

#   vpc_security_group_ids = [each.value.sg]

#   tags = {
#     Name = "EC2-${each.key}"
#   }
# }
