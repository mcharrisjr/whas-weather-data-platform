moved {
  from = aws_ecs_task_definition.hourly_forecasted_weather
  to   = aws_ecs_task_definition.scrape_ecs_tasks["whas-weather-scrape-hourly-weather-forecast"]
}

moved {
  from = aws_ecs_task_definition.daily_forecasted_weather
  to   = aws_ecs_task_definition.scrape_ecs_tasks["whas-weather-scrape-daily-weather-forecast"]
}

moved {
  from = aws_ecs_task_definition.hourly_observed_weather
  to   = aws_ecs_task_definition.scrape_ecs_tasks["whas-weather-scrape-hourly-weather-observation"]
}

moved {
  from = aws_cloudwatch_log_group.hourly_forecasted_weather
  to   = aws_cloudwatch_log_group.ecs_scrape_log_groups["whas-weather-scrape-hourly-weather-forecast"]
}

moved {
  from = aws_cloudwatch_log_group.daily_forecasted_weather
  to   = aws_cloudwatch_log_group.ecs_scrape_log_groups["whas-weather-scrape-daily-weather-forecast"]
}

moved {
  from = aws_cloudwatch_log_group.hourly_observed_weather
  to   = aws_cloudwatch_log_group.ecs_scrape_log_groups["whas-weather-scrape-hourly-weather-observation"]
}
