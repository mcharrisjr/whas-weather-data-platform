resource "aws_cloudwatch_log_group" "log_groups" {
  for_each = local.ecs_tasks

  name              = "/ecs/${each.value.family}"
  retention_in_days = 7
}
