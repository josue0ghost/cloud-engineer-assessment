resource "aws_s3_bucket" "cea_datalake" {
  bucket = var.datalake_bucket_name
}

resource "aws_s3_bucket" "cea_athena_results" {
  bucket = var.athena_results_bucket_name
}