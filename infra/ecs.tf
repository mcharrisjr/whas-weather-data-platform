resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"
}

resource "aws_ecs_task_definition" "hourly_forecasted_weather" {
  family                   = "${var.project_name}-scrape-hourly-forecasted-weather"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  container_definitions = jsonencode([
    {
      name      = "scrape"
      image     = "${aws_ecr_repository.scrape.repository_url}:${var.image_tag}"
      essential = true
      environment = [
        { "name" : "WHAS_WEATHER_RAW_GLUE_CATALOG_DATABASE", "value" : aws_glue_catalog_database.raw.name },
        { "name" : "WHAS_WEATHER_RAW_S3_BUCKET", "value" : aws_s3_bucket.raw.bucket },
      ]
      command = ["--type", "forecast", "--frequency", "hourly"]
    }
  ])

  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  task_role_arn      = aws_iam_role.ecs_task_scrape.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }
}

resource "aws_ecs_task_definition" "daily_forecasted_weather" {
  family                   = "${var.project_name}-scrape-daily-forecasted-weather"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  container_definitions = jsonencode([
    {
      name      = "scrape"
      image     = aws_ecr_repository.scrape.repository_url
      essential = true
      environment = [
        { "name" : "WHAS_WEATHER_RAW_GLUE_CATALOG_DATABASE", "value" : aws_glue_catalog_database.raw.name },
        { "name" : "WHAS_WEATHER_RAW_S3_BUCKET", "value" : aws_s3_bucket.raw.bucket },
      ]
      command = ["--type", "forecast", "--frequency", "daily"]
    }
  ])

  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  task_role_arn      = aws_iam_role.ecs_task_scrape.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }
}

resource "aws_ecs_task_definition" "hourly_observed_weather" {
  family                   = "${var.project_name}-scrape-hourly-observed-weather"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  container_definitions = jsonencode([
    {
      name      = "scrape"
      image     = "${aws_ecr_repository.scrape.repository_url}:${var.image_tag}"
      essential = true
      environment = [
        { "name" : "WHAS_WEATHER_RAW_GLUE_CATALOG_DATABASE", "value" : aws_glue_catalog_database.raw.name },
        { "name" : "WHAS_WEATHER_RAW_S3_BUCKET", "value" : aws_s3_bucket.raw.bucket },
      ]
      command = ["--type", "observation", "--frequency", "hourly"]
    }
  ])

  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  task_role_arn      = aws_iam_role.ecs_task_scrape.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }
}

resource "aws_ecs_task_definition" "dbt_build" {
  family                   = "${var.project_name}-dbt-build"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  container_definitions = jsonencode([
    {
      name      = "dbt"
      image     = "${aws_ecr_repository.dbt_build.repository_url}:${var.image_tag}"
      essential = true
      environment = [
        { "name" : "AWS_REGION", "value" : local.aws_region },
        { "name" : "WHAS_WEATHER_ATHENA_QUERY_RESULTS_S3_BUCKET", "value" : aws_s3_bucket.athena_query_results.bucket },
        { "name" : "WHAS_WEATHER_INTERMEDIATE_S3_BUCKET", "value" : aws_s3_bucket.intermediate.bucket },
        { "name" : "WHAS_WEATHER_MART_S3_BUCKET", "value" : aws_s3_bucket.mart.bucket }
      ]
      command = ["dbt", "build", "--select", "+marts"]
    }
  ])

  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  task_role_arn      = aws_iam_role.ecs_task_dbt_build.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }
}
