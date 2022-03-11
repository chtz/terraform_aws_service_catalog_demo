# AWS Service Catalog POC: lib_s3_demo

How to provision an AWS Service Catalog product with terraform.

Disclaimer: Do not currently use Terraform for this task because the service catalog support is incomplete (missing data sources) and the tooling is immature or broken.

# Terraform root module

- aws.tf:  AWS backends and S3 provider
- main.tf: Creates two provisioned products using a child module that encapsulates all the workarounds required for them

# Terraform child module: lib_s3_client

- main.tf: Uses the default terraform AWS provider for provisioning service catalog products and uses the generic awscc AWS provider and some dirty hacks to get the output of the provisioned products

# Howto

    export AWS_PROFILE=...
    export AWS_DEFAULT_REGION=eu-central-1
    terraform init
    terraform workspace new As3demo
    terraform apply --auto-approve

# Issues

Tested in early March 2022 with:

    Terraform v1.1.6 (<- most recent as of today)
    on darwin_arm64
    + provider registry.terraform.io/hashicorp/aws v3.74.3
    + provider registry.terraform.io/hashicorp/awscc v0.13.0

## Terrafor apply error for a missing parameter (too generic and no hints regarding the actual error):

    aws_servicecatalog_provisioned_product.singlenodehana: Still creating... [20s elapsed]
    ╷
    │ Error: error describing Service Catalog Provisioned Product (pp-lx33vhwnrifk6): unexpected state 'ERROR', wanted target 'AVAILABLE'. last error: %!s(<nil>)
    │ 
    │   with aws_servicecatalog_provisioned_product.singlenodehana,
    │   on main.tf line 7, in resource "aws_servicecatalog_provisioned_product" "singlenodehana":
    │    7: resource "aws_servicecatalog_provisioned_product" "singlenodehana" {

## FYI: Error feedback in web console for a missing parameter:

    AmazonCloudFormationException Parameters: [FooTagValue] must have values 
    (Service: AmazonCloudFormation; Status Code: 400; Error Code: ValidationError; 
    Request ID: d08a2751-0649-439f-b353-2daa49b0a036; Proxy: null)

## Terraform (re-) apply error after adding missing param (terraform bug?):

    aws_servicecatalog_provisioned_product.singlenodehana: Refreshing state... [id=pp-lx33vhwnrifk6]
    ╷
    │ Error: error describing Service Catalog Provisioned Product (pp-lx33vhwnrifk6): unexpected state 'ERROR', wanted target 'AVAILABLE'. last error: %!s(<nil>)
    │ 
    │   with aws_servicecatalog_provisioned_product.singlenodehana,
    │   on main.tf line 23, in resource "aws_servicecatalog_provisioned_product" "singlenodehana":
    │   23: resource "aws_servicecatalog_provisioned_product" "singlenodehana" {

## Terraform destroy error for a provisioned product in error state (=> manual terminate in web console required)

    aws_servicecatalog_provisioned_product.singlenodehana: Refreshing state... [id=pp-lx33vhwnrifk6]
    ╷
    │ Error: error describing Service Catalog Provisioned Product (pp-lx33vhwnrifk6): unexpected state 'ERROR', wanted target 'AVAILABLE'. last error: %!s(<nil>)
    │ 
    │   with aws_servicecatalog_provisioned_product.singlenodehana,
    │   on main.tf line 32, in resource "aws_servicecatalog_provisioned_product" "singlenodehana":
    │   32: resource "aws_servicecatalog_provisioned_product" "singlenodehana" {

## Terraform apply error after updating a parameter to an invalid value (=> manual terminate in web console required)

    ╷
    │ Error: error describing Service Catalog Provisioned Product (pp-bj64wc46zs2ma): unexpected state 'TAINTED', wanted target 'AVAILABLE'. last error: %!s(<nil>)
    │ 
    │   with module.bucket1.aws_servicecatalog_provisioned_product.provisionedproduct,
    │   on lib_s3_client/main.tf line 9, in resource "aws_servicecatalog_provisioned_product" "provisionedproduct":
    │    9: resource "aws_servicecatalog_provisioned_product" "provisionedproduct" {
    │ 
    ╵

# KILLER! Changing the product version of a provisioned product HAS NO EFFECT, but terraform does not complain either (terraform bug?) (=> manual version update via web console)

    resource "aws_servicecatalog_provisioned_product" "provisionedproduct" {
      ...
      provisioning_artifact_name = "libs3-v2"
      ...
    }

