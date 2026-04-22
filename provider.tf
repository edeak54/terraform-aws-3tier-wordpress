terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.41.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Project   = "3Tier-Wordpress"
      ManagedBy = "Terraform"
    }
  }
}
