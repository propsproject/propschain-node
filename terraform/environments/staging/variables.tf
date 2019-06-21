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

variable "ethereum_confirmation_block" {
  description = "The amount of ethereum blocks to wait before we process them into the sidechain. Don't choose anything less than 15"
  default = 15
}

variable "ethereum_url" {
  description = "The ethereum url to use (e.g infura)."
}

variable "etherscan_api_key" {
  description = "The etherscan api key. This key needs to be created on etherscan"
}

variable "etherscan_url" {
  description = "The etherscan url. We provide this url"
}

variable "props_token_contract_address" {
  description = "At what address can we find the props contract. We provide this"
}

variable "props_token_deployed_block" {
  description = "What is the blockId of the props token contract. We provide this"
}

variable "sawtooth_pk" {
  description = "The sawtooth private key to use. We provide this pk"
}

variable "validator_url" {
  description = "The validator url, will need to remove this here, since it's always the same url for each instance."
}

variable "network_private_key" {
  description = "The zeromq private key, we provide this"
}

variable "network_public_key" {
  description = "The zeromq public key, we provide this"
}
