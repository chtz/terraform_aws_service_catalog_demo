variable "bucket" {
  type    = string
}

variable "tag" {
  type    = string
}

resource "aws_servicecatalog_provisioned_product" "provisionedproduct" {
  name = var.bucket
  product_name = "libs3-product"
  provisioning_artifact_name = "libs3-v2"
  
  provisioning_parameters {
        key = "BucketName"
        value = var.bucket
  }

  provisioning_parameters {
        key = "FooTagValue"
        value = var.tag
  }
}

data "aws_cloudcontrolapi_resource" "provisionedproduct" {
  identifier = aws_servicecatalog_provisioned_product.provisionedproduct.id
  type_name  = "AWS::ServiceCatalog::CloudFormationProvisionedProduct"
}

data "aws_cloudformation_stack" "provisionedproductstack" {
  name = regex("/(.+)/", jsondecode(data.aws_cloudcontrolapi_resource.provisionedproduct.properties).CloudformationStackArn)[0]
}

output "bucket" {
  value = data.aws_cloudformation_stack.provisionedproductstack.outputs["Bucket"]
}
