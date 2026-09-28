locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  aws_region     = data.aws_region.current.region

  project_slug = replace(var.project_name, "-", "_")

  scrape_ecs_tasks = {
    "${var.project_name}-scrape-hourly-weather-forecast" : ["--type", "forecast", "--frequency", "hourly"],
    "${var.project_name}-scrape-daily-weather-forecast" : ["--type", "forecast", "--frequency", "daily"],
    "${var.project_name}-scrape-hourly-weather-observation" : ["--type", "observation", "--frequency", "hourly"],
  }

  dbt_build_ecs_task = "${var.project_name}-dbt-build"
}
