// ---------------------------------------------------------------------------------------------------------------------
//  Terraform profile to use. Create a profile called sidechain-staging in your ~/.aws/credentials file
// ---------------------------------------------------------------------------------------------------------------------
provider "aws" {
  region                  = "${var.aws_region}"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "sidechain-staging"
}

