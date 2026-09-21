locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  aws_region     = data.aws_region.current.region

  project_slug = replace(var.project_name, "-", "_")

  raw_database_name          = "${local.project_slug}_raw"
  intermediate_database_name = "${local.project_slug}_intermediate"
  mart_database_name         = "${local.project_slug}_mart"

  raw_hourly_forecast_table_name    = "hourly_forecast"
  raw_daily_forecast_table_name     = "daily_forecast"
  raw_hourly_observation_table_name = "hourly_observation"

  raw_bucket_name          = "${var.project_name}-raw-${local.aws_account_id}-${local.aws_region}-an"
  intermediate_bucket_name = "${var.project_name}-intermediate-${local.aws_account_id}-${local.aws_region}-an"
  mart_bucket_name         = "${var.project_name}-mart-${local.aws_account_id}-${local.aws_region}-an"

  athena_query_results_bucket_name = "${var.project_name}-athena-query-results-${local.aws_account_id}-${local.aws_region}-an"

  scrape_ecr_repository_name = "${var.project_name}/scrape"
  dbt_ecr_repository_name    = "${var.project_name}/dbt-build"
}
