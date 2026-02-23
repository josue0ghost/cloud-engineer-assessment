# Create a new replication subnet group
resource "aws_dms_replication_subnet_group" "cea_replication_subnet_group" {
  replication_subnet_group_description = "Subnet group for cea DMS replication instance"
  replication_subnet_group_id          = "cea-dms-replication-subnet-group"

  subnet_ids = var.subnet_ids

  tags = {
    Name = "cea-dms-replication-subnet-group"
    Usage = var.project_name
  }
}

# Create a new replication instance
resource "aws_dms_replication_instance" "cea_replication_instance" {
  allocated_storage             = 50
  apply_immediately             = true
  auto_minor_version_upgrade    = true
  availability_zone             = var.aws_availability_zone1
  engine_version                = "3.1.4"
  multi_az                      = false
  publicly_accessible           = false
  replication_instance_class    = var.dms_instance_class
  replication_instance_id       = var.dms_instance_name
  replication_subnet_group_id   = aws_dms_replication_subnet_group.cea_replication_subnet_group.id

  vpc_security_group_ids        = var.security_group_ids

  depends_on = [
    aws_iam_role_policy_attachment.dms-cloudwatch-logs-role-AmazonDMSCloudWatchLogsRole,
    aws_iam_role_policy_attachment.dms-vpc-role-AmazonDMSVPCManagementRole
  ]

  tags = {
    Name = var.dms_instance_name
    Usage = var.project_name
  }
}

resource "aws_dms_endpoint" "source" {
  endpoint_id   = "aurora-source"
  endpoint_type = "source"
  engine_name   = "aurora-postgresql"

  server_name   = var.aurora_endpoint
  port          = var.aurora_port
  database_name = var.aurora_database
  username      = var.aurora_username
  password      = var.aurora_password

  ssl_mode      = "require"

  tags = {
    Name = "aurora-source-endpoint"
    Usage = var.project_name
  }
}

resource "aws_dms_s3_endpoint" "target_s3" {
  endpoint_id               = "s3-target"
  endpoint_type             = "target"


  bucket_folder             = "dms-data"
  bucket_name               = aws_s3_bucket.cea_datalake.bucket

  compression_type          = "GZIP"
  data_format               = "parquet"

  # Athena optimization settings for partitioning the data by date
  date_partition_enabled    = true
  date_partition_sequence   = "YYYYMMDD"
  date_partition_delimiter  = "SLASH"

  # Data Lake best practices for CDC workloads
  cdc_inserts_only          = true
  include_op_for_full_load  = false

  service_access_role_arn   = aws_iam_role.dms_s3_role.arn
}

# Table Mappings

locals {
  table_mappings = jsonencode({
    rules = [
      {
        "rule-type" = "selection"
        "rule-id"   = "1"
        "rule-name" = "get-trx-tables"
        "object-locator" = {
          "schema-name" = "public"
          "table-name"  = "trx_%"
        }
        "rule-action" = "include"
      }
    ]
  })
}

# Replication Task

resource "aws_dms_replication_task" "aurora_to_datalake_task" {
  replication_task_id       = "aurora-to-datalake-task"
  migration_type            = "cdc"
  replication_instance_arn  = aws_dms_replication_instance.cea_replication_instance.replication_instance_arn
  source_endpoint_arn       = aws_dms_endpoint.source.endpoint_arn
  target_endpoint_arn       = aws_dms_s3_endpoint.target_s3.endpoint_arn

  table_mappings            = local.table_mappings

  lifecycle {
    ignore_changes          = [ replication_task_settings ]
  }

  tags = {
    Usage = var.project_name
  }
}

# Work Group

resource "aws_athena_workgroup" "cea_datalake_wg" {
  name = "cea-datalake-workgroup"

  configuration {
    enforce_workgroup_configuration = true

    result_configuration {
      output_location = "s3://${aws_s3_bucket.cea_athena_results.bucket}/results/"
    }
  }
}