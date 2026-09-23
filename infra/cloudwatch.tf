resource "aws_cloudwatch_log_group" "hourly_forecasted_weather" {
  name              = "/ecs/${local.scrape_hourly_forecasted_weather_task_name}"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "daily_forecasted_weather" {
  name              = "/ecs/${local.scrape_daily_forecasted_weather_task_name}"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "hourly_observed_weather" {
  name              = "/ecs/${local.scrape_hourly_observed_weather_task_name}"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "dbt_build" {
  name              = "/ecs/${local.dbt_build_task_name}"
  retention_in_days = 7
}
