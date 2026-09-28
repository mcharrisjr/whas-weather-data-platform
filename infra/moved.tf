moved {
  from = aws_ecr_repository.repositories["whas-weather/scrape"]
  to   = aws_ecr_repository.repositories["scrape"]
}

moved {
  from = aws_ecr_repository.repositories["whas-weather/dbt-build"]
  to   = aws_ecr_repository.repositories["dbt"]
}

moved {
  from = aws_ecr_lifecycle_policy.policies["whas-weather/scrape"]
  to   = aws_ecr_lifecycle_policy.policies["scrape"]
}

moved {
  from = aws_ecr_lifecycle_policy.policies["whas-weather/dbt-build"]
  to   = aws_ecr_lifecycle_policy.policies["dbt"]
}
