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

# DMS Variables
variable "subnet_ids" {
  default = [
    "subnet-12345678",
    "subnet-12345679",
  ]
  description = "Subnets IDs where the DMS replication instance will be launched"
}

variable "security_group_ids" {
  default = [
    "sg-12345678",
  ]
  description = "Security Group IDs to be associated with the DMS replication instance. Must have network access to Aurora"
  
}

variable "dms_instance_name" {
  default = "cea-dms-replication-instance"
}

variable "dms_instance_class" {
  default = "dms.t3.medium"
}

variable "datalake_bucket_name" {
  default = "cea-datalake-bucket"
}

variable "athena_results_bucket_name" {
  default = "cea-athena-results-bucket"
}

variable "aurora_endpoint" {
  type = string
  description = "The endpoint of the Aurora PostgreSQL cluster"
}
variable "aurora_port" { 
  default = 5432 
}
variable "aurora_username" {
  description = "The username for the Aurora PostgreSQL cluster"
}
variable "aurora_password" {
  sensitive = true
}
variable "aurora_database" {
  description = "The database name in the Aurora PostgreSQL cluster to migrate"
}
