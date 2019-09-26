variable "environment_name" {
  description = "The environment name"
}

variable "app_name" {
  description = "The name of the app"
}

variable "size" {
  description = "The size of the disk"
}

variable "type" {
  description = "The type of disk"
  default     = "gp2"
}

variable "availability_zones" {
  description = "The availability zones"
}

variable "service_name" {
  description = "The name of the service using this disk"
}

variable "k8s_name" {
  description = "The name of the k8s cluster"
}

variable "snapshot_id" {
  default = ""
  description = "The snapshot id you want to use to create the volume"
}
