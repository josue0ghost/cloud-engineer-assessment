# AWS Configuration Variables

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_availability_zone1" {
  type    = string
  default = "us-east-1a"
}

variable "aws_availability_zone2" {
  type    = string
  default = "us-east-1b"
}

# Project Configuration Tags

variable "project_name" {
  type    = string
  default = "cloud-engineer-assessment"
}

# App Mesh Variables
variable "namespace" {
  type    = string
  default = "default"
}

variable "mesh_name" {
  type    = string
  default = "cea-app-mesh"
}

variable "virtual_node_name" {
  type    = string
  default = "api-customer-node"
}

variable "service_name" {
  type    = string
  default = "api-customer"
}

variable "app_port" {
  type    = number
  default = 8080

  validation {
    condition     = var.app_port > 0 && var.app_port < 65536
    error_message = "app_port must be a valid TCP port between 1 and 65535."
  }
}
