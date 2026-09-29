resource "aws_sfn_state_machine" "daily" {
  name     = "${var.project_name}-daily"
  role_arn = aws_iam_role.step_function.arn

  definition = templatefile("${path.module}/templates/daily_definition.json.tftpl", {
    ecs_cluster_arn                   = aws_ecs_cluster.main.arn
    scrape_ecs_task_definition_arn    = aws_ecs_task_definition.scrape_ecs_tasks["${var.project_name}-scrape-daily-weather-forecast"].arn
    dbt_build_ecs_task_definition_arn = aws_ecs_task_definition.dbt_build.arn
    subnets                           = jsonencode([aws_subnet.public.id])
    security_groups                   = jsonencode([aws_security_group.ecs_task.id])
    raw_database_name                 = aws_glue_catalog_database.databases["raw"].name
    raw_daily_forecast_table_name     = aws_glue_catalog_table.tables["raw_daily_forecast"].name
    athena_query_results_bucket       = aws_s3_bucket.buckets["athena_query_results"].bucket
  })
}


resource "aws_sfn_state_machine" "hourly" {
  name     = "${var.project_name}-hourly"
  role_arn = aws_iam_role.step_function.arn

  definition = templatefile("${path.module}/templates/hourly_definition.json.tftpl", {
    ecs_cluster_arn                            = aws_ecs_cluster.main.arn
    scrape_forecast_ecs_task_definition_arn    = aws_ecs_task_definition.scrape_ecs_tasks["${var.project_name}-scrape-hourly-weather-forecast"].arn
    scrape_observation_ecs_task_definition_arn = aws_ecs_task_definition.scrape_ecs_tasks["${var.project_name}-scrape-hourly-weather-observation"].arn
    dbt_build_ecs_task_definition_arn          = aws_ecs_task_definition.dbt_build.arn
    subnets                                    = jsonencode([aws_subnet.public.id])
    security_groups                            = jsonencode([aws_security_group.ecs_task.id])
    raw_database_name                          = aws_glue_catalog_database.databases["raw"].name
    raw_hourly_forecast_table_name             = aws_glue_catalog_table.tables["raw_hourly_forecast"].name
    raw_hourly_observation_table_name          = aws_glue_catalog_table.tables["raw_hourly_observation"].name
    athena_query_results_bucket                = aws_s3_bucket.buckets["athena_query_results"].bucket
  })
}

