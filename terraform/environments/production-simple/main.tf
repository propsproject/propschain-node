// ---------------------------------------------------------------------------------------------------------------------
//  Terraform profile to use. Create a profile called sidechain-production in your ~/.aws/credentials file
// ---------------------------------------------------------------------------------------------------------------------
provider "aws" {
  region                  = "${var.aws_region}"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "sidechain-production"
}

// ---------------------------------------------------------------------------------------------------------------------
//  Terraform state file backend, state will be stored on S3
// ---------------------------------------------------------------------------------------------------------------------
terraform {
  backend "s3" {
    bucket                 = "propschain-nodes"
    key                    = "production-simple"
    region                 = "us-east-1"
    skip_region_validation = true
    workspace_key_prefix   = "infrastructure"
    profile                = "sidechain-staging"
    dynamodb_table         = "terraform-state-lock-dynamo"
  }
}
