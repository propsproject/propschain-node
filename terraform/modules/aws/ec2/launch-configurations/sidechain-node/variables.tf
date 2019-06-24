variable "app_name" {
  description = "Application Name"
}

variable "environment_name" {
  description = "Environment to deploy to"
}

variable "vpc_id" {
  description = "The vpc id in which to create the security group"
}

variable "ami" {
  description = "The base AMI to use"
}

variable "instance_type" {
  default = "m4.xlarge"
  description = "The size of the machine"
}

variable "key_name" {
  description = "The key name"
}

variable "volume_size_gb" {
  description = "The size of the disk in GB"
}

variable "subnet_ids" {
  description = "The subnet ids for the autoscaling group"
}

variable "availability_zones" {
  description = "The avail zones"
}

variable "validator_url" {

}

variable "ethereum_url" {

}

variable "props_token_contract_address" {

}

variable "sawtooth_pk" {

}

variable "etherscan_api_key" {

}

variable "etherscan_url" {

}

variable "props_token_deployed_block" {

}

variable "ethereum_confirmation_block" {

}

variable "network_private_key" {

}

variable "network_public_key" {

}

variable "desired_capacity" {

}

variable "min_size" {

}

variable "max_size" {

}

variable "sawtooth_rest_url" {

}

variable "sawtooth_rest_port" {

}

variable "validator_seed_url" {

}
