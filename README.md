# AWS Service Catalog POC

Disclaimer
- Not ready for production use (security: CloudFormation template publicly accesible)!
- Antipatterns (it is actually a bad idea to create Service Catalog Product wrappers for single AWS resources)!

# lib_s3

A simple AWS Service Catalog demo product that can be used to "order" an S3 bucket:
- Terraform module to automatically create the service catalog product (and a demo portfolio).
- CloudFormation JSON template used by the service catalog product.

# lib_s3_demo

Provisioning an AWS Service Catalog product with Terraform (however, due to the current immature support in Terraform, this is not recommended).

# lib_s3_demo_cf

Provisioning an AWS Service Catalog product using CloudFormation (provided "as is" - this was not the focus of this POC).

# Issues

Service Catalog not yet fully supported in terraform (=> ugly workarounds required)

see https://github.com/hashicorp/terraform-provider-aws/issues/20024 
