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
  default = "t2.micro"
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

variable "seconds_in_day" {

}

variable "frequency_hours" {
  default = "*"
}

variable "frequency_minutes" {
  default = "5"
}

variable "rewards_start_timestamp" {
  description = "The start timestamp of the rewards"
}

variable "sawtooth_rest_url" {

}

variable "sawtooth_rest_port" {

}

variable "validator_seed_url" {

}

variable "which_docker_compose" {

}

variable "validator_submission_pk" {

}

variable "sawtooth_rest_https" {
  description = "True or false"
}

variable "state_api_url" {
  description = "Url for state api activity summary"
}

variable "opentsdb_password" {
  description = "The password for the metrics server"
}
