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

variable "props_token_contract_address" {
  description = "The props token address"
}

variable "which_docker_compose" {
  description = "Which docker compose to use"
}

variable "validator_submission_pk" {
  description = "The submission pk"
}

variable "seconds_in_day" {
  description = "Second in day, for staging should be 3600"
}

variable "frequency_hours" {
  description = "What hour do you want to run rewards in the cronjob, default *"
}

variable "frequency_minutes" {
  description = "What minute do you want to run rewards in the cronjob, default 5"
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

variable "gas_price" {
  description = "Gas price to use when submitting rewards (gwei)"
}

variable "submit_rewards_retry_gas_inc" {
  description = "How much to increment gas price in each retry (gwei)"
}

