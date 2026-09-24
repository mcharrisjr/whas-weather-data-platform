moved {
  from = aws_s3_bucket.raw
  to   = aws_s3_bucket.buckets["whas-weather-raw-597341305438-us-east-1-an"]
}

moved {
  from = aws_s3_bucket.intermediate
  to   = aws_s3_bucket.buckets["whas-weather-intermediate-597341305438-us-east-1-an"]
}

moved {
  from = aws_s3_bucket.mart
  to   = aws_s3_bucket.buckets["whas-weather-mart-597341305438-us-east-1-an"]
}

moved {
  from = aws_s3_bucket.athena_query_results
  to   = aws_s3_bucket.buckets["whas-weather-athena-query-results-597341305438-us-east-1-an"]
}

moved {
  from = aws_s3_bucket_versioning.raw
  to   = aws_s3_bucket_versioning.bucket_versioning["whas-weather-raw-597341305438-us-east-1-an"]
}

moved {
  from = aws_s3_bucket_versioning.intermediate
  to   = aws_s3_bucket_versioning.bucket_versioning["whas-weather-intermediate-597341305438-us-east-1-an"]
}

moved {
  from = aws_s3_bucket_versioning.mart
  to   = aws_s3_bucket_versioning.bucket_versioning["whas-weather-mart-597341305438-us-east-1-an"]
}

moved {
  from = aws_s3_bucket_versioning.athena_query_results
  to   = aws_s3_bucket_versioning.bucket_versioning["whas-weather-athena-query-results-597341305438-us-east-1-an"]
}

moved {
  from = aws_s3_bucket_public_access_block.raw
  to   = aws_s3_bucket_public_access_block.public_access_blocks["whas-weather-raw-597341305438-us-east-1-an"]
}

moved {
  from = aws_s3_bucket_public_access_block.intermediate
  to   = aws_s3_bucket_public_access_block.public_access_blocks["whas-weather-intermediate-597341305438-us-east-1-an"]
}

moved {
  from = aws_s3_bucket_public_access_block.mart
  to   = aws_s3_bucket_public_access_block.public_access_blocks["whas-weather-mart-597341305438-us-east-1-an"]
}

moved {
  from = aws_s3_bucket_public_access_block.athena_query_results
  to   = aws_s3_bucket_public_access_block.public_access_blocks["whas-weather-athena-query-results-597341305438-us-east-1-an"]
}
