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

# Subnet Configuration Variables

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr_block, 0))
    error_message = "vpc_cidr_block must be a valid CIDR block."
  }
}

variable "private_subnet_1_cidr" {
  type    = string
  default = "10.0.1.0/24" # 254 usable IPs

  validation {
    condition     = can(cidrhost(var.private_subnet_1_cidr, 0))
    error_message = "private_subnet_1_cidr must be a valid CIDR block."
  }
}

variable "private_subnet_2_cidr" {
  type    = string
  default = "10.0.2.0/24" # 254 usable IPs

  validation {
    condition     = can(cidrhost(var.private_subnet_2_cidr, 0))
    error_message = "private_subnet_2_cidr must be a valid CIDR block."
  }
}

variable "public_subnet_1_cidr" {
  type    = string
  default = "10.0.3.0/24" # 254 usable IPs

  validation {
    condition     = can(cidrhost(var.public_subnet_1_cidr, 0))
    error_message = "public_subnet_1_cidr must be a valid CIDR block."
  }
}

variable "public_subnet_2_cidr" {
  type    = string
  default = "10.0.4.0/24" # 254 usable IPs

  validation {
    condition     = can(cidrhost(var.public_subnet_2_cidr, 0))
    error_message = "public_subnet_2_cidr must be a valid CIDR block."
  }
}

# Project Configuration Tags

variable "project_name" {
  type    = string
  default = "cloud-engineer-assessment"
}

variable "bucket_name" {
  type    = string
  default = "cloud-engineer-assessment-bucket"
}

variable "namespace" {
  type    = string
  default = "default"
}

variable "service_account_name" {
  type    = string
  default = "s3-access-sa"
}
