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

# Subnet Configurations Variables

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "private_subnet_1_cidr" {
  default = "10.0.1.0/24" # 254 usable IPs
}

variable "private_subnet_2_cidr" {
  default = "10.0.2.0/24" # 254 usable IPs
}

variable "public_subnet_1_cidr" {
  default = "10.0.3.0/24" # 254 usable IPs
}

variable "public_subnet_2_cidr" {
  default = "10.0.4.0/24" # 254 usable IPs
}

# Project Configuration Tags

variable "project_name" {
  default = "cloud-engineer-assessment"
}

variable "bucket_name" {
  default = "cloud-engineer-assessment-bucket"
}

variable "namespace" {
  default = "default"
}

variable "service_account_name" {
  default = "s3-access-sa"
}
