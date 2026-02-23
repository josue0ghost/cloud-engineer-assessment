# AWS Configuration Variables

variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "aws_availability_zone1" {
  type = string
  default = "us-east-1a"
}

variable "aws_availability_zone2" {
  type = string
  default = "us-east-1b"
}

# Project Configuration Tags

variable "project_name" {
  type = string
  default = "cloud-engineer-assessment"
}

# DMS Variables

variable "subnet_ids" {
  type = list(string)
  default = [
    "subnet-12345678",
    "subnet-12345679",
  ]
  description = "Subnets IDs where the DMS replication instance will be launched"

  validation {
    condition = length(var.subnet_ids) > 0
    error_message = "subnet_ids must contain at least one subnet."
  }
}

variable "security_group_ids" {
  type = list(string)
  default = [
    "sg-12345678",
  ]
  description = "Security Group IDs to be associated with the DMS replication instance. Must have network access to Aurora"

  validation {
    condition = length(var.security_group_ids) > 0
    error_message = "security_group_ids must contain at least one security group."
  }
}

variable "dms_instance_name" {
  type = string
  default = "cea-dms-replication-instance"
}

variable "dms_instance_class" {
  type = string
  default = "dms.t3.medium"

  validation {
    condition     = can(regex("^dms\\.t3\\.(micro|small|medium)$", var.dms_instance_class))
    error_message = "dms_instance_class must be one of: dms.t3.micro, dms.t3.small, dms.t3.medium."
  }
}

variable "datalake_bucket_name" {
  type = string
  default = "cea-datalake-bucket"
}

variable "athena_results_bucket_name" {
  type = string
  default = "cea-athena-results-bucket"
}

variable "aurora_endpoint" {
  type = string
  description = "The endpoint of the Aurora PostgreSQL cluster"
}

variable "aurora_port" {
  type = number
  default = 5432

  validation {
    condition = var.aurora_port > 0 && var.aurora_port < 65536
    error_message = "aurora_port must be a valid TCP port between 1 and 65535."
  }
}

variable "aurora_username" {
  type = string
  description = "The username for the Aurora PostgreSQL cluster"
}

variable "aurora_password" {
  type = string
  sensitive = true
}

variable "aurora_database" {
  type = string
  description = "The database name in the Aurora PostgreSQL cluster to migrate"
}
