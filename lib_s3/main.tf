data "aws_caller_identity" "current" {}

locals {
  account = data.aws_caller_identity.current.account_id
}

resource "aws_s3_bucket" "cftemplates" {
  bucket        = "${local.account}-libs3-cftemplates"
  acl           = "private"
  force_destroy = true
}

resource "aws_s3_bucket_object" "cftemplate" {
  bucket = aws_s3_bucket.cftemplates.id
  key    = "libs3.json"
  source = "libs3.json"
  etag   = filemd5("libs3.json")

  #FIXME
  acl = "public-read"
}

resource "aws_s3_bucket_object" "cftemplatev2" {
  bucket = aws_s3_bucket.cftemplates.id
  key    = "libs3v2.json"
  source = "libs3v2.json"
  etag   = filemd5("libs3v2.json")

  #FIXME
  acl = "public-read"
}

resource "aws_servicecatalog_product" "product" {
  name  = "libs3-product"
  owner = "foo"
  type  = "CLOUD_FORMATION_TEMPLATE"

  provisioning_artifact_parameters {
    name         = "libs3-v1"
    template_url = "https://s3.eu-central-1.amazonaws.com/${aws_s3_bucket.cftemplates.id}/${aws_s3_bucket_object.cftemplate.id}"
    type         = "CLOUD_FORMATION_TEMPLATE"
  }
}

resource "aws_servicecatalog_provisioning_artifact" "productversion2" {
  name         = "libs3-v2"
  product_id   = aws_servicecatalog_product.product.id
  type         = "CLOUD_FORMATION_TEMPLATE"
  template_url = "https://s3.eu-central-1.amazonaws.com/${aws_s3_bucket.cftemplates.id}/${aws_s3_bucket_object.cftemplatev2.id}"
}

resource "aws_servicecatalog_portfolio" "portfolio" {
  name          = "libs3-portfolio"
  description   = "foo"
  provider_name = "foo"
}

resource "aws_servicecatalog_product_portfolio_association" "portfolioproduct" {
  portfolio_id = aws_servicecatalog_portfolio.portfolio.id
  product_id   = aws_servicecatalog_product.product.id
}

resource "aws_servicecatalog_principal_portfolio_association" "portfolioproductforcaller" {
  portfolio_id  = aws_servicecatalog_portfolio.portfolio.id
  principal_arn = data.aws_caller_identity.current.arn
}

output "product_name" {
  value = "libs3-product"
}

output "product_version_name" {
  value = "libs3-v2"
}
