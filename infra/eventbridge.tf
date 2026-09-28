locals {
  schedules = {
    hourly = {
      name                = "${var.project_name}-hourly"
      schedule_expression = "cron(30 * * * ? *)"
      state               = "ENABLED"
      target_arn          = aws_sfn_state_machine.hourly.arn
    }
    daily = {
      name                = "${var.project_name}-daily"
      schedule_expression = "cron(0 16 * * ? *)"
      state               = "ENABLED"
      target_arn          = aws_sfn_state_machine.daily.arn
    }
  }
}

resource "aws_scheduler_schedule" "schedules" {
  for_each = local.schedules

  name                         = each.value.name
  schedule_expression          = each.value.schedule_expression
  schedule_expression_timezone = "America/New_York"
  state                        = each.value.state

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = each.value.target_arn
    role_arn = aws_iam_role.eventbridge_scheduler.arn
  }
}
