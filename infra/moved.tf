moved {
  from = aws_cloudwatch_log_group.ecs_scrape_log_groups["whas-weather-scrape-hourly-weather-forecast"]
  to   = aws_cloudwatch_log_group.log_groups["scrape_hourly_forecast"]
}

moved {
  from = aws_cloudwatch_log_group.ecs_scrape_log_groups["whas-weather-scrape-hourly-weather-observation"]
  to   = aws_cloudwatch_log_group.log_groups["scrape_hourly_observation"]
}

moved {
  from = aws_cloudwatch_log_group.ecs_scrape_log_groups["whas-weather-scrape-daily-weather-forecast"]
  to   = aws_cloudwatch_log_group.log_groups["scrape_daily_forecast"]
}

moved {
  from = aws_ecs_task_definition.scrape_ecs_tasks["whas-weather-scrape-hourly-weather-forecast"]
  to   = aws_ecs_task_definition.scrape_ecs_tasks["scrape_hourly_forecast"]
}

moved {
  from = aws_ecs_task_definition.scrape_ecs_tasks["whas-weather-scrape-hourly-weather-observation"]
  to   = aws_ecs_task_definition.scrape_ecs_tasks["scrape_hourly_observation"]
}

moved {
  from = aws_ecs_task_definition.scrape_ecs_tasks["whas-weather-scrape-daily-weather-forecast"]
  to   = aws_ecs_task_definition.scrape_ecs_tasks["scrape_daily_forecast"]
}
