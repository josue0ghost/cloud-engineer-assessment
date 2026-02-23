resource "aws_s3_bucket" "cea_bucket" {
  bucket = var.bucket_name

  tags = {
    Usage = var.project_name
  }
}