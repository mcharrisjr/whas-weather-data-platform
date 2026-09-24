resource "aws_cloudwatch_log_group" "ecs_scrape_log_groups" {
  for_each = local.scrape_ecs_tasks

  name              = "/ecs/${each.key}"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "dbt_build" {
  name              = "/ecs/${local.dbt_build_ecs_task}"
  retention_in_days = 7
}
