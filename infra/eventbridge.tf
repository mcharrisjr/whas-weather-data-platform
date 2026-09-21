resource "aws_scheduler_schedule" "hourly" {
  name                         = "${var.project_name}-hourly"
  schedule_expression          = "cron(5 * * * ? *)"
  schedule_expression_timezone = "America/New_York"
  state                        = "DISABLED"

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = aws_sfn_state_machine.hourly.arn
    role_arn = aws_iam_role.eventbridge_scheduler.arn
  }
}

resource "aws_scheduler_schedule" "daily" {
  name                         = "${var.project_name}-daily"
  schedule_expression          = "cron(5 0 * * ? *)"
  schedule_expression_timezone = "America/New_York"
  state                        = "DISABLED"

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = aws_sfn_state_machine.daily.arn
    role_arn = aws_iam_role.eventbridge_scheduler.arn
  }
}
