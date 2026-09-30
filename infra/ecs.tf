locals {
  ecs_tasks = {
    scrape_hourly_forecast = {
      family  = "scrape-hourly-weather-forecast"
      command = ["--type", "forecast", "--frequency", "hourly"]
      cpu     = "256"
      memory  = "512"
    }
    scrape_daily_forecast = {
      family  = "scrape-daily-weather-forecast"
      command = ["--type", "forecast", "--frequency", "daily"]
      cpu     = "256"
      memory  = "512"
    }
    scrape_hourly_observation = {
      family  = "scrape-hourly-weather-observation"
      command = ["--type", "observation", "--frequency", "hourly"]
      cpu     = "256"
      memory  = "512"
    }
    dbt_build = {
      family  = "dbt-build"
      command = ["dbt", "build", "--select", "+marts"]
      cpu     = "256"
      memory  = "512"
    }
  }
}

resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"
}

resource "aws_ecs_task_definition" "scrape_ecs_tasks" {
  for_each = local.ecs_tasks

  family                   = each.value.family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = each.value.cpu
  memory                   = each.value.memory
  container_definitions = jsonencode([
    {
      name      = each.value.family
      image     = "${aws_ecr_repository.repositories["scrape"].repository_url}:${var.image_tag}"
      essential = true
      environment = [
        { "name" : "WHAS_WEATHER_RAW_GLUE_CATALOG_DATABASE", "value" : aws_glue_catalog_database.databases["raw"].name },
        { "name" : "WHAS_WEATHER_RAW_S3_BUCKET", "value" : aws_s3_bucket.buckets["raw"].bucket },
      ]
      command = each.value.command

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.log_groups[each.key].name
          "awslogs-region"        = local.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  task_role_arn      = aws_iam_role.ecs_task_scrape.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

resource "aws_ecs_task_definition" "dbt_build" {
  family                   = local.ecs_tasks["dbt_build"].family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = local.ecs_tasks["dbt_build"].cpu
  memory                   = local.ecs_tasks["dbt_build"].memory
  container_definitions = jsonencode([
    {
      name      = local.ecs_tasks["dbt_build"].family
      image     = "${aws_ecr_repository.repositories["dbt"].repository_url}:${var.image_tag}"
      essential = true
      environment = [
        { "name" : "AWS_REGION", "value" : local.aws_region },
        { "name" : "WHAS_WEATHER_ATHENA_QUERY_RESULTS_S3_BUCKET", "value" : aws_s3_bucket.buckets["athena_query_results"].bucket },
        { "name" : "WHAS_WEATHER_INTERMEDIATE_S3_BUCKET", "value" : aws_s3_bucket.buckets["intermediate"].bucket },
        { "name" : "WHAS_WEATHER_MART_S3_BUCKET", "value" : aws_s3_bucket.buckets["mart"].bucket }
      ]
      command = local.ecs_tasks["dbt_build"].command

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.log_groups["dbt_build"].name
          "awslogs-region"        = local.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  task_role_arn      = aws_iam_role.ecs_task_dbt_build.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}
