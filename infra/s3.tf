resource "aws_s3_bucket" "raw" {
  bucket           = local.raw_bucket_name
  bucket_namespace = "account-regional"
}

resource "aws_s3_bucket_versioning" "raw" {
  bucket = aws_s3_bucket.raw.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "raw" {
  bucket = aws_s3_bucket.raw.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "intermediate" {
  bucket           = local.intermediate_bucket_name
  bucket_namespace = "account-regional"
}

resource "aws_s3_bucket_versioning" "intermediate" {
  bucket = aws_s3_bucket.intermediate.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "intermediate" {
  bucket = aws_s3_bucket.intermediate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "mart" {
  bucket           = local.mart_bucket_name
  bucket_namespace = "account-regional"
}

resource "aws_s3_bucket_versioning" "mart" {
  bucket = aws_s3_bucket.mart.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "mart" {
  bucket = aws_s3_bucket.mart.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "athena_query_results" {
  bucket           = local.athena_query_results_bucket_name
  bucket_namespace = "account-regional"
}

resource "aws_s3_bucket_public_access_block" "athena_query_results" {
  bucket = aws_s3_bucket.athena_query_results.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "athena_query_results" {
  bucket = aws_s3_bucket.athena_query_results.bucket

  rule {
    id = "one-day-expiration"

    expiration {
      days = 7
    }

    status = "Enabled"
  }
}
