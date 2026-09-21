locals {
  glue_arn_prefix = "arn:aws:glue:${local.aws_region}:${local.aws_account_id}"
  ecs_task_execution_role_arn = "arn:aws:iam:aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ecs_task_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_scrape" {
  name               = "${var.project_name}-ecs-task-scrape-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_trust.json
}

data "aws_iam_policy_document" "raw_bucket_write" {
  statement {
    actions   = ["s3:PutObject"]
    resources = [
      "${aws_s3_bucket.raw.arn}/${local.raw_database_name}_${local.raw_hourly_forecast_table_name}/*",
      "${aws_s3_bucket.raw.arn}/${local.raw_database_name}_${local.raw_daily_forecast_table_name}/*",
      "${aws_s3_bucket.raw.arn}/${local.raw_database_name}_${local.raw_hourly_observation_table_name}/*",
    ]
  }
}

resource "aws_iam_policy" "raw_bucket_write" {
  name   = "${var.project_name}-raw-bucket-write-policy"
  policy = data.aws_iam_policy_document.raw_bucket_write.json
}

resource "aws_iam_policy_attachment" "raw_bucket_write" {
  role = aws_iam_role.ecs_task_scrape.name
  policy_arn = aws_iam_policy.raw_bucket_write.arn
}

resource "aws_iam_role" "ecs_task_dbt_build" {
  name               = "${var.project_name}-ecs-task-dbt-build-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_trust.json
}

data "aws_iam_policy_document" "dbt_build" {
  statement {
    actions = [
      "athena:StartQueryExecution",
      "athena:GetQueryExecution",
      "athena:GetQueryResults",
      "athena:GetWorkGroup",
      "athena:GetDataCatalog",
      "athena:StopQueryExecution",
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "glue:GetDatabase",
      "glue:GetDatabases",
      "glue:GetTable",
      "glue:GetTables",
      "glue:GetPartitions",
      "glue:CreateDatabase",
      "glue:CreateTable",
      "glue:UpdateTable",
      "glue:DeleteTable",
      "glue:BatchCreatePartition",
      "glue:BatchUpdatePartition",
      "glue:BatchDeletePartition",
    ]
    resources = [
      "${local.glue_arn_prefix}:catalog",
      "${local.glue_arn_prefix}:database/${local.raw_database_name}",
      "${local.glue_arn_prefix}:database/${local.staging_database_name}",
      "${local.glue_arn_prefix}:database/${local.intermediate_database_name}",
      "${local.glue_arn_prefix}:database/${local.mart_database_name}",
      "${local.glue_arn_prefix}:table/${local.raw_database_name}/*",
      "${local.glue_arn_prefix}:table/${local.staging_database_name}/*",
      "${local.glue_arn_prefix}:table/${local.intermediate_database_name}/*",
      "${local.glue_arn_prefix}:table/${local.mart_database_name}/*",
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]
    resources = [
      "arn:aws:s3:::${var.project_name}-*",
      "arn:aws:s3:::${var.project_name}-*/*",
    ]
  }
}

resource "aws_iam_policy" "dbt_build" {
  name = "${var.project_name}-dbt-build-policy"
  policy = data.aws_iam_policy_document.dbt_build.json
}

resource "aws_iam_policy_attachment" "dbt_build" {
  role = aws_iam_role.ecs_task_dbt_build.name
  policy_arn = aws_iam_policy.dbt_build.arn
}

resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.project_name}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_trust.json
}

resource "aws_iam_policy_attachment" "ecs_task_execution" {
  role = aws_iam_role.ecs_task_execution.name
  policy_arn = local.ecs_task_execution_role_arn
}
