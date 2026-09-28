moved {
  from = aws_scheduler_schedule.hourly
  to   = aws_scheduler_schedule.schedules["hourly"]
}

moved {
  from = aws_scheduler_schedule.daily
  to   = aws_scheduler_schedule.schedules["daily"]
}
