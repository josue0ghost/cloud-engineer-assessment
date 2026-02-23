# AWS Configuration Variables

variable "aws_region" {
  default = "us-east-1"
}

variable "aws_availability_zone1" {
  default = "us-east-1a"
}

variable "aws_availability_zone2" {
  default = "us-east-1b"
}

# Project Configuration Tags

variable "project_name" {
  default = "cloud-engineer-assessment"
}

# App Mesh Variables
variable "namespace" {
  default = "default"
}

variable "mesh_name" {
  default = "cea-app-mesh"
}

variable "virtual_node_name" {
  default = "api-customer-node"
}

variable "service_name" {
  default = "api-customer"
}

variable "app_port" {
  default = 8080
}
