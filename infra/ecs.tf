locals {
  cpu    = "256"
  memory = "512"

  operating_system_family = "LINUX"
  cpu_architecture        = "X86_64"
}

resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"
}

resource "aws_ecs_task_definition" "scrape_ecs_tasks" {
  for_each = local.scrape_ecs_tasks

  family                   = each.key
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = local.cpu
  memory                   = local.memory
  container_definitions = jsonencode([
    {
      name      = each.key
      image     = "${aws_ecr_repository.repositories["${var.project_name}/scrape"].repository_url}:${var.image_tag}"
      essential = true
      environment = [
        { "name" : "WHAS_WEATHER_RAW_GLUE_CATALOG_DATABASE", "value" : aws_glue_catalog_database.raw.name },
        { "name" : "WHAS_WEATHER_RAW_S3_BUCKET", "value" : aws_s3_bucket.buckets["${var.project_name}-raw-${local.aws_account_id}-${local.aws_region}-an"].bucket },
      ]
      command = each.value

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_scrape_log_groups[each.key].name
          "awslogs-region"        = local.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  task_role_arn      = aws_iam_role.ecs_task_scrape.arn

  runtime_platform {
    operating_system_family = local.operating_system_family
    cpu_architecture        = local.cpu_architecture
  }
}

resource "aws_ecs_task_definition" "dbt_build" {
  family                   = local.dbt_build_ecs_task
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  container_definitions = jsonencode([
    {
      name      = "dbt-build"
      image     = "${aws_ecr_repository.repositories["${var.project_name}/dbt-build"].repository_url}:${var.image_tag}"
      essential = true
      environment = [
        { "name" : "AWS_REGION", "value" : local.aws_region },
        { "name" : "WHAS_WEATHER_ATHENA_QUERY_RESULTS_S3_BUCKET", "value" : aws_s3_bucket.buckets["${var.project_name}-athena-query-results-${local.aws_account_id}-${local.aws_region}-an"].bucket },
        { "name" : "WHAS_WEATHER_INTERMEDIATE_S3_BUCKET", "value" : aws_s3_bucket.buckets["${var.project_name}-intermediate-${local.aws_account_id}-${local.aws_region}-an"].bucket },
        { "name" : "WHAS_WEATHER_MART_S3_BUCKET", "value" : aws_s3_bucket.buckets["${var.project_name}-mart-${local.aws_account_id}-${local.aws_region}-an"].bucket }
      ]
      command = ["dbt", "build", "--select", "+marts"]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.dbt_build.name
          "awslogs-region"        = local.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  task_role_arn      = aws_iam_role.ecs_task_dbt_build.arn

  runtime_platform {
    operating_system_family = local.operating_system_family
    cpu_architecture        = local.cpu_architecture
  }
}
