data "aws_caller_identity" "current" {}

locals {
  account = data.aws_caller_identity.current.account_id
}

module "bucket1" {
  source = "./lib_s3_client"
  bucket = "${local.account}-demobucket1"
  tag    = "Halo Welt"
}

module "bucket2" {
  source = "./lib_s3_client"
  bucket = "${local.account}-demobucket2"
  tag    = "Hello World"
}

output "demobucket1" {
  value = module.bucket1.bucket
}

output "demobucket2" {
  value = module.bucket2.bucket
}
