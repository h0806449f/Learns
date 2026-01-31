terraform {
  # 關係到本機 terraform version
  required_version = ">=1.13.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-3"

  default_tags {
    tags = {
      Owner     = "Henry Lee"
      ManagedBy = "Terraform"
    }
  }
}
