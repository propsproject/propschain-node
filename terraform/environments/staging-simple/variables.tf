variable "app_name" {
  default = "The app name"
}

variable "environment_name" {
  default = "The environment name (staging, production, ...)"
}

variable "key_name" {
  default = "The key pair name to use when creating instances"
}

variable "aws_region" {
  description = "The AWS region"
}

variable "aws_availability_zones" {
  description = "The availability zones"
}

variable "vpc_id" {
  description = "In which vpc do you want to deploy the instances"
}

variable "ami" {
  description = "The ami id to use as the base image for your instances"
}

variable "subnet_ids" {
  description = "The subnet ids"
}

variable "nodes_count" {
  description = "How many sidechain nodes do you want to run"
}

variable "instance_disk_size" {
  description = "The disk size of each instance"
}

variable "ethereum_url" {
  description = "The ethereum url to use (e.g infura)."
}

variable "sawtooth_pk" {
  description = "The sawtooth pk to use"
}

variable "props_token_contract_address" {
  description = "The props token address"
}

variable "which_docker_compose" {
  description = "Which docker compose to use"
}

variable "validator_submission_pk" {
  description = "The submission pk"
}
