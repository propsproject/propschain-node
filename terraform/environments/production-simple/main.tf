// ---------------------------------------------------------------------------------------------------------------------
//  Terraform profile to use. Create a profile called sidechain-production in your ~/.aws/credentials file
// ---------------------------------------------------------------------------------------------------------------------
provider "aws" {
  region                  = "${var.aws_region}"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "sidechain-production"
}

