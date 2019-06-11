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
