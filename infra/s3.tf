resource "aws_s3_bucket" "weather_raw" {
  bucket           = "${local.project}-raw-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.region}-an"
  bucket_namespace = "account-regional"
}

resource "aws_s3_bucket_versioning" "weather_raw" {
  bucket = aws_s3_bucket.weather_raw.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "weather_raw" {
  bucket = aws_s3_bucket.weather_raw.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "weather_intermediate" {
  bucket           = "${local.project}-intermediate-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.region}-an"
  bucket_namespace = "account-regional"
}

resource "aws_s3_bucket_versioning" "weather_intermediate" {
  bucket = aws_s3_bucket.weather_intermediate.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "weather_intermediate" {
  bucket = aws_s3_bucket.weather_intermediate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "weather_mart" {
  bucket           = "${local.project}-mart-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.region}-an"
  bucket_namespace = "account-regional"
}

resource "aws_s3_bucket_versioning" "weather_mart" {
  bucket = aws_s3_bucket.weather_mart.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "weather_mart" {
  bucket = aws_s3_bucket.weather_mart.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "athena_staging" {
  bucket           = "${local.project}-athena-query-results-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.region}-an"
  bucket_namespace = "account-regional"
}

resource "aws_s3_bucket_public_access_block" "athena_staging" {
  bucket = aws_s3_bucket.athena_staging.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "athena_staging" {
  bucket = aws_s3_bucket.athena_staging.bucket

  rule {
    id = "one-day-expiration"

    expiration {
      days = 1
    }

    status = "Enabled"
  }
}
