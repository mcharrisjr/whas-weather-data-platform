locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  aws_region     = data.aws_region.current.region

  project_slug = replace(var.project_name, "-", "_")

  raw_database_name          = "${local.project_slug}_raw"
  staging_database_name      = "${local.project_slug}_staging"
  intermediate_database_name = "${local.project_slug}_intermediate"
  mart_database_name         = "${local.project_slug}_mart"

  raw_hourly_forecast_table_name    = "hourly_forecast"
  raw_daily_forecast_table_name     = "daily_forecast"
  raw_hourly_observation_table_name = "hourly_observation"

  scrape_hourly_forecasted_weather_task_name = "${var.project_name}-scrape-hourly-forecasted-weather"
  scrape_daily_forecasted_weather_task_name  = "${var.project_name}-scrape-daily-forecasted-weather"
  scrape_hourly_observed_weather_task_name   = "${var.project_name}-scrape-hourly-forecasted-weather"
  dbt_build_task_name                        = "${var.project_name}-dbt-build"
}
