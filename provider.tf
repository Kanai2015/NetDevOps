terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.72.0"
    }
  }
}


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
