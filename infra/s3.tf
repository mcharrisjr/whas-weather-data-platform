locals {
  buckets = toset([
    "${var.project_name}-raw-${local.aws_account_id}-${local.aws_region}-an",
    "${var.project_name}-intermediate-${local.aws_account_id}-${local.aws_region}-an",
    "${var.project_name}-mart-${local.aws_account_id}-${local.aws_region}-an",
    "${var.project_name}-athena-query-results-${local.aws_account_id}-${local.aws_region}-an"
  ])
}

resource "aws_s3_bucket" "buckets" {
  for_each = local.buckets

  bucket           = each.value
  bucket_namespace = "account-regional"
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  for_each = { for k, v in aws_s3_bucket.buckets : k => v if k != "${var.project_name}-athena-query-results-${local.aws_account_id}-${local.aws_region}-an" }

  bucket = each.value.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_blocks" {
  for_each = aws_s3_bucket.buckets

  bucket = each.value.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "athena_query_results" {
  bucket = aws_s3_bucket.buckets["${var.project_name}-athena-query-results-${local.aws_account_id}-${local.aws_region}-an"].bucket

  rule {
    id = "one-day-expiration"

    expiration {
      days = 7
    }

    status = "Enabled"
  }
}
