# Provider configuration
provider "aws" {
  region = "us-east-1"  # Global region for Cloud WAN
}

# Create a global network
resource "aws_networkmanager_global_network" "global_network" {
  description = "Global network for multi-region deployment"
}

# Create a core network
resource "aws_networkmanager_core_network" "core_network" {
  global_network_id = aws_networkmanager_global_network.global_network.id
  description       = "Core network for multi-region deployment"
}

# Define the core network policy
resource "aws_networkmanager_core_network_policy_attachment" "policy" {
  core_network_id = aws_networkmanager_core_network.core_network.id
  policy_document = jsonencode({
    version = "2021.12"
    core-network-configuration = {
      asn-ranges = ["64512-65534"]
      edge-locations = [
        { location = "ap-south-1" },    # Mumbai
        { location = "ap-southeast-2" }, # Sydney
        { location = "eu-west-2" }      # London
      ]
    }
    segments = [
      {
        name = "development"
        isolate-attachments = false
        require-attachment-acceptance = false
      },
      {
        name = "production"
        isolate-attachments = true
        require-attachment-acceptance = true
      },
      {
        name = "networking"
        isolate-attachments = false
        require-attachment-acceptance = false
      }
    ]
    segment-actions = [
      {
        action = "share"
        mode = "attachment-route"
        segment = "networking"
        share-with = "*"
      }
    ]
    attachment-policies = [
      {
        rule-number = 100
        conditions = [
          {
            type = "tag-exists"
            key = "Segment"
          }
        ]
        action = {
          association-method = "tag"
          tag-value-of-key = "Segment"
        }
      }
    ]
  })
}

# Create dev VPC attachments - Mumbai
resource "aws_networkmanager_vpc_attachment" "mumbai_dev_attachment" {
  core_network_id = aws_networkmanager_core_network.core_network.id
  vpc_arn         = aws_vpc.mumbai_dev.arn
  subnet_arns     = [aws_subnet.mumbai_dev.arn]
  tags = {
    Segment = "development"
  }
}

# Create dev VPC attachments - Sydney
resource "aws_networkmanager_vpc_attachment" "sydney_dev_attachment" {
  core_network_id = aws_networkmanager_core_network.core_network.id
  vpc_arn         = aws_vpc.sydney_dev.arn
  subnet_arns     = [aws_subnet.sydney_dev.arn]
  tags = {
    Segment = "development"
  }
}

# Create production VPC attachments - Mumbai

resource "aws_networkmanager_vpc_attachment" "mumbai_prod_attachment" {
  core_network_id = aws_networkmanager_core_network.core_network.id
  vpc_arn         = aws_vpc.mumbai_prod.arn
  subnet_arns     = [aws_subnet.mumbai_prod.arn]
  tags = {
    Segment = "production"
  }
}

# Create production VPC attachments - Sydney

resource "aws_networkmanager_vpc_attachment" "sydney_prod_attachment" {
  core_network_id = aws_networkmanager_core_network.core_network.id
  vpc_arn         = aws_vpc.sydney_prod.arn
  subnet_arns     = [aws_subnet.sydney_prod.arn]
  tags = {
    Segment = "production"
  }
}

resource "aws_networkmanager_vpc_attachment" "london_net_attachment" {
  core_network_id = aws_networkmanager_core_network.core_network.id
  vpc_arn         = aws_vpc.london_net.arn
  subnet_arns     = [aws_subnet.london_net.arn]
  tags = {
    Segment = "networking"
  }
}
