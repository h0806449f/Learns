

1. Repo 配置
	1. infra_live
	2. infra_modules

```bash cpp title:root.hcl 
# 共通 remote state (s3 在 payer account)
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = "nv-unicorn-terragrunt-prod-s3bucket-state-file"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
```
--- 
```bash cpp title:terragrunt.hcl
# root provider and backend
include {
  path = find_in_parent_folders("root.hcl")
}

# terraform module
terraform {
  source = "../../../../infra_modules/noc_devops_agent_master_role"
}

generate "linked_account_providers" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::296569421253:role/TerragruntRole"
  }
}
EOF
}
```