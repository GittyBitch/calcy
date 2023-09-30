provider "aws" {
  region = "eu-central-1"
}

terraform {
  required_version = "~> 1.5.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.19.0"
    }
  }
}

