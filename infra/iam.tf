locals {
  glue_arn_prefix             = "arn:aws:glue:${local.aws_region}:${local.aws_account_id}"
  ecs_task_execution_role_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
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
    actions = ["s3:PutObject"]
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
  name       = "${var.project_name}-raw-bucket-write-policy-attachment"
  roles      = [aws_iam_role.ecs_task_scrape.name]
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
      "glue:GetTableVersion",
      "glue:GetTableVersions",
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
  name   = "${var.project_name}-dbt-build-policy"
  policy = data.aws_iam_policy_document.dbt_build.json
}

resource "aws_iam_policy_attachment" "dbt_build" {
  name       = "${var.project_name}-dbt-build-policy-attachment"
  roles      = [aws_iam_role.ecs_task_dbt_build.name]
  policy_arn = aws_iam_policy.dbt_build.arn
}

resource "aws_iam_role" "ecs_task_execution" {
  name               = "${var.project_name}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_trust.json
}

resource "aws_iam_policy_attachment" "ecs_task_execution" {
  name       = "${var.project_name}-ecs-task-execution-policy-attachment"
  roles      = [aws_iam_role.ecs_task_execution.name]
  policy_arn = local.ecs_task_execution_role_arn
}

data "aws_iam_policy_document" "eventbridge_scheduler_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["scheduler.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eventbridge_scheduler" {
  name               = "${var.project_name}-eventbridge-scheduler-role"
  assume_role_policy = data.aws_iam_policy_document.eventbridge_scheduler_trust.json
}

data "aws_iam_policy_document" "eventbridge_scheduler" {
  statement {
    actions = ["states:StartExecution"]
    resources = [
      aws_sfn_state_machine.hourly.arn,
      aws_sfn_state_machine.daily.arn,
    ]
  }
}

resource "aws_iam_policy" "eventbridge_scheduler" {
  name   = "${var.project_name}-eventbridge-scheduler-policy"
  policy = data.aws_iam_policy_document.eventbridge_scheduler.json
}

resource "aws_iam_policy_attachment" "eventbridge_scheduler" {
  name       = "${var.project_name}-eventbridge-scheduler-policy-attachment"
  roles      = [aws_iam_role.eventbridge_scheduler.name]
  policy_arn = aws_iam_policy.eventbridge_scheduler.arn
}

data "aws_iam_policy_document" "step_function_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "step_function" {
  name               = "${var.project_name}-step-function"
  assume_role_policy = data.aws_iam_policy_document.step_function_trust.json
}

data "aws_iam_policy_document" "step_function" {
  statement {
    actions = [
      "ecs:RunTask",
      "ecs:StopTask",
      "ecs:DescribeTasks",
    ]
    resources = ["*"]
  }

  statement {
    actions = ["iam:PassRole"]
    resources = [
      aws_iam_role.ecs_task_execution.arn,
      aws_iam_role.ecs_task_scrape.arn,
      aws_iam_role.ecs_task_dbt_build.arn,
    ]
  }

  statement {
    actions = [
      "events:PutRule",
      "events:PutTargets",
      "events:RemoveTargets",
      "events:DeleteRule",
      "events:DescribeRule"
    ]
    resources = [
      "arn:aws:events:*:${local.aws_account_id}:rule/StepFunctionsGetEventsForECSTaskRule"
    ]
  }

  statement {
    actions = [
      "events:CreateManagedRule",
      "events:PutManagedRule"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "athena:StartQueryExecution",
      "athena:GetQueryExecution",
      "athena:GetQueryResults",
      "athena:StopQueryExecution",
    ]
    resources = [
      "arn:aws:athena:${local.aws_region}:${local.aws_account_id}:workgroup/primary"
    ]
  }

  statement {
    actions = [
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.raw.bucket}",
      "arn:aws:s3:::${aws_s3_bucket.raw.bucket}/*",
      "arn:aws:s3:::${aws_s3_bucket.athena_query_results.bucket}",
      "arn:aws:s3:::${aws_s3_bucket.athena_query_results.bucket}/*",
    ]
  }

  statement {
    actions = [
      "glue:GetDatabase",
      "glue:GetTable",
      "glue:GetPartition",
      "glue:GetPartitions",
      "glue:CreatePartition",
      "glue:BatchCreatePartition"
    ]
    resources = [
      "arn:aws:glue:${local.aws_region}:${local.aws_account_id}:catalog",
      "arn:aws:glue:${local.aws_region}:${local.aws_account_id}:database/${aws_glue_catalog_database.raw.name}",
      "arn:aws:glue:${local.aws_region}:${local.aws_account_id}:table/${aws_glue_catalog_database.raw.name}/${aws_glue_catalog_table.raw_hourly_forecast.name}",
      "arn:aws:glue:${local.aws_region}:${local.aws_account_id}:table/${aws_glue_catalog_database.raw.name}/${aws_glue_catalog_table.raw_daily_forecast.name}",
      "arn:aws:glue:${local.aws_region}:${local.aws_account_id}:table/${aws_glue_catalog_database.raw.name}/${aws_glue_catalog_table.raw_hourly_observation.name}",
    ]
  }
}

resource "aws_iam_policy" "step_function" {
  name   = "${var.project_name}-step-function-policy"
  policy = data.aws_iam_policy_document.step_function.json
}

resource "aws_iam_policy_attachment" "step_function" {
  name       = "${var.project_name}-step-function-policy-attachment"
  roles      = [aws_iam_role.step_function.name]
  policy_arn = aws_iam_policy.step_function.arn
}
