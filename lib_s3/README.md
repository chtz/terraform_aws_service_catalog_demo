# AWS Service Catalog POC: lib_s3

A simple AWS Service Catalog demo product that can be used to "order" an S3 bucket,

# Howto

    export AWS_PROFILE=...
    export AWS_DEFAULT_REGION=eu-central-1
    terraform init
    terraform workspace new Alibs3
    terraform apply --auto-approve

# Terraform module to automatically create the service catalog product (and a demo portfolio).

- aws.tf:  AWS backends and S3 provider
- main.tf: S3 bucket for CloudFormation template, resources required to create a ClousFormation-based Service Catalog product version in a demo portfolio

# CloudFormation JSON template used by the service catalog product.

- libs3.json:   CloudFormation template used by version 1 of the Service Catalog Product
- libs3v2.json: CloudFormation template used by version 2 of the Service Catalog Product
