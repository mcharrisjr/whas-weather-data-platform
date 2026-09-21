output "scrape_ecr_repository_url" {
  description = "ECR repository URL for scraping."
  value       = aws_ecr_repository.scrape.repository_url
}

output "dbt_build_ecr_repository_url" {
  description = "ECR repository URL for building with dbt."
  value       = aws_ecr_repository.dbt_build.repository_url
}
