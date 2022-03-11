terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }

    awscc = {
      source  = "hashicorp/awscc"
      version = "~> 0.1"
    }
  }

  backend "s3" {
    bucket = "multi-demo-chtz-tfstate"
    key    = "libs3/terraform"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}

provider "awscc" {
  region = "eu-central-1"
}
