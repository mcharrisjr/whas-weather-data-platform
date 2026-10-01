locals {
  databases = {
    raw          = { name = "${local.project_slug}_raw" }
    staging      = { name = "${local.project_slug}_staging" }
    mart         = { name = "${local.project_slug}_mart" }
  }

  tables = {
    raw_hourly_forecast = {
      name              = "hourly_forecast"
      external_location = "s3://${aws_s3_bucket.buckets["raw"].bucket}/${aws_glue_catalog_database.databases["raw"].name}_hourly_forecast/"
      columns = [
        { name = "forecasted_for", type = "string" },
        { name = "temperature_f", type = "int" },
        { name = "chance_of_precipitation", type = "double" },
        { name = "wind_speed_mph", type = "int" },
        { name = "wind_direction", type = "string" },
        { name = "scraped_at", type = "string" },
      ]
      partition_keys = [
        { name = "scraped_date", type = "string" },
      ]
    }
    raw_daily_forecast = {
      name              = "daily_forecast"
      external_location = "s3://${aws_s3_bucket.buckets["raw"].bucket}/${aws_glue_catalog_database.databases["raw"].name}_daily_forecast/"
      columns = [
        { name = "forecast_date", type = "string" },
        { name = "high_temperature_f", type = "int" },
        { name = "low_temperature_f", type = "int" },
        { name = "chance_of_precipitation", type = "double" },
        { name = "wind_speed_mph", type = "int" },
        { name = "wind_direction", type = "string" },
        { name = "scraped_at", type = "string" },
      ]
      partition_keys = [
        { name = "scraped_date", type = "string" },
      ]
    }
    raw_hourly_observation = {
      name              = "hourly_observation"
      external_location = "s3://${aws_s3_bucket.buckets["raw"].bucket}/${aws_glue_catalog_database.databases["raw"].name}_hourly_observation/"
      columns = [
        { name = "observed_at", type = "string" },
        { name = "temperature_f", type = "int" },
        { name = "feels_like_f", type = "int" },
        { name = "humidity", type = "double" },
        { name = "chance_of_precipitation", type = "double" },
        { name = "wind_speed_mph", type = "int" },
        { name = "wind_direction", type = "string" },
        { name = "condition_", type = "string" },
        { name = "scraped_at", type = "string" },
      ]
      partition_keys = [
        { name = "observation_date", type = "string" },
      ]
    }
  }
}

resource "aws_glue_catalog_database" "databases" {
  for_each = local.databases

  name = each.value.name
}

resource "aws_glue_catalog_table" "tables" {
  for_each = local.tables

  name          = each.value.name
  database_name = aws_glue_catalog_database.databases["raw"].name
  table_type    = "EXTERNAL_TABLE"

  storage_descriptor {
    location      = each.value.external_location
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hive.hcatalog.data.JsonSerDe"
    }

    dynamic "columns" {
      for_each = each.value.columns
      content {
        name = columns.value.name
        type = columns.value.type
      }
    }
  }

  dynamic "partition_keys" {
    for_each = each.value.partition_keys
    content {
      name = partition_keys.value.name
      type = partition_keys.value.type
    }
  }
}
