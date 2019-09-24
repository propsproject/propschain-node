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

variable "ethereum_url" {

}

variable "props_token_contract_address" {

}

variable "which_docker_compose" {

}

variable "validator_submission_pk" {

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
  description = "The sawtooth rest url"
}

variable "sawtooth_rest_port" {
  description = "The sawtooth rest port"
}

variable "sawtooth_rest_https" {
  description = "True or false"
}

variable "state_api_url" {
  description = "Url for state api activity summary"
}