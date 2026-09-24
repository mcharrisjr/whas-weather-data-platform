moved {
  from = aws_ecr_repository.scrape
  to   = aws_ecr_repository.repositories["whas-weather/scrape"]
}

moved {
  from = aws_ecr_repository.dbt_build
  to   = aws_ecr_repository.repositories["whas-weather/dbt-build"]
}

moved {
  from = aws_ecr_lifecycle_policy.scrape
  to   = aws_ecr_lifecycle_policy.policies["whas-weather/scrape"]
}

moved {
  from = aws_ecr_lifecycle_policy.dbt
  to   = aws_ecr_lifecycle_policy.policies["whas-weather/dbt-build"]
}


