moved {
  from = aws_s3_bucket.buckets["whas-weather-raw-597341305438-us-east-1-an"]
  to   = aws_s3_bucket.buckets["raw"]
}

moved {
  from = aws_s3_bucket.buckets["whas-weather-intermediate-597341305438-us-east-1-an"]
  to   = aws_s3_bucket.buckets["intermediate"]
}

moved {
  from = aws_s3_bucket.buckets["whas-weather-mart-597341305438-us-east-1-an"]
  to   = aws_s3_bucket.buckets["mart"]
}

moved {
  from = aws_s3_bucket.buckets["whas-weather-athena-query-results-597341305438-us-east-1-an"]
  to   = aws_s3_bucket.buckets["athena_query_results"]
}

moved {
  from = aws_s3_bucket_versioning.bucket_versioning["whas-weather-raw-597341305438-us-east-1-an"]
  to   = aws_s3_bucket_versioning.bucket_versioning["raw"]
}

moved {
  from = aws_s3_bucket_versioning.bucket_versioning["whas-weather-intermediate-597341305438-us-east-1-an"]
  to   = aws_s3_bucket_versioning.bucket_versioning["intermediate"]
}

moved {
  from = aws_s3_bucket_versioning.bucket_versioning["whas-weather-mart-597341305438-us-east-1-an"]
  to   = aws_s3_bucket_versioning.bucket_versioning["mart"]
}

moved {
  from = aws_s3_bucket_public_access_block.public_access_blocks["whas-weather-raw-597341305438-us-east-1-an"]
  to   = aws_s3_bucket_public_access_block.public_access_blocks["raw"]
}

moved {
  from = aws_s3_bucket_public_access_block.public_access_blocks["whas-weather-intermediate-597341305438-us-east-1-an"]
  to   = aws_s3_bucket_public_access_block.public_access_blocks["intermediate"]
}

moved {
  from = aws_s3_bucket_public_access_block.public_access_blocks["whas-weather-mart-597341305438-us-east-1-an"]
  to   = aws_s3_bucket_public_access_block.public_access_blocks["mart"]
}

moved {
  from = aws_s3_bucket_public_access_block.public_access_blocks["whas-weather-athena-query-results-597341305438-us-east-1-an"]
  to   = aws_s3_bucket_public_access_block.public_access_blocks["athena_query_results"]
}




