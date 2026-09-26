resource "aws_glue_catalog_database" "raw" {
  name = local.raw_database_name
}

resource "aws_glue_catalog_database" "staging" {
  name = local.staging_database_name
}

resource "aws_glue_catalog_database" "intermediate" {
  name = local.intermediate_database_name
}

resource "aws_glue_catalog_database" "mart" {
  name = local.mart_database_name
}

resource "aws_glue_catalog_table" "raw_hourly_forecast" {
  name          = local.raw_hourly_forecast_table_name
  database_name = aws_glue_catalog_database.raw.name
  table_type    = "EXTERNAL_TABLE"

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.buckets["${var.project_name}-raw-${local.aws_account_id}-${local.aws_region}-an"].bucket}/${aws_glue_catalog_database.raw.name}_${local.raw_hourly_forecast_table_name}/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hive.hcatalog.data.JsonSerDe"
    }

    columns {
      name = "forecasted_for"
      type = "string"
    }

    columns {
      name = "temperature_f"
      type = "int"
    }

    columns {
      name = "chance_of_precipitation"
      type = "double"
    }

    columns {
      name = "wind_speed_mph"
      type = "int"
    }

    columns {
      name = "wind_direction"
      type = "string"
    }

    columns {
      name = "scraped_at"
      type = "string"
    }
  }

  partition_keys {
    name = "scraped_date"
    type = "string"
  }
}

resource "aws_glue_catalog_table" "raw_daily_forecast" {
  name          = local.raw_daily_forecast_table_name
  database_name = aws_glue_catalog_database.raw.name
  table_type    = "EXTERNAL_TABLE"

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.buckets["${var.project_name}-raw-${local.aws_account_id}-${local.aws_region}-an"].bucket}/${aws_glue_catalog_database.raw.name}_${local.raw_daily_forecast_table_name}/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hive.hcatalog.data.JsonSerDe"
    }

    columns {
      name = "forecast_date"
      type = "string"
    }

    columns {
      name = "high_temperature_f"
      type = "int"
    }

    columns {
      name = "low_temperature_f"
      type = "int"
    }

    columns {
      name = "chance_of_precipitation"
      type = "double"
    }

    columns {
      name = "wind_speed_mph"
      type = "int"
    }

    columns {
      name = "wind_direction"
      type = "string"
    }

    columns {
      name = "scraped_at"
      type = "string"
    }
  }

  partition_keys {
    name = "scraped_date"
    type = "string"
  }
}

resource "aws_glue_catalog_table" "raw_hourly_observation" {
  name          = local.raw_hourly_observation_table_name
  database_name = aws_glue_catalog_database.raw.name
  table_type    = "EXTERNAL_TABLE"

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.buckets["${var.project_name}-raw-${local.aws_account_id}-${local.aws_region}-an"].bucket}/${aws_glue_catalog_database.raw.name}_${local.raw_hourly_observation_table_name}/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hive.hcatalog.data.JsonSerDe"
    }

    columns {
      name = "observed_at"
      type = "string"
    }

    columns {
      name = "temperature_f"
      type = "int"
    }

    columns {
      name = "feels_like_f"
      type = "int"
    }

    columns {
      name = "humidity"
      type = "double"
    }

    columns {
      name = "chance_of_precipitation"
      type = "double"
    }

    columns {
      name = "wind_speed_mph"
      type = "int"
    }

    columns {
      name = "wind_direction"
      type = "string"
    }

    columns {
      name = "condition_"
      type = "string"
    }

    columns {
      name = "scraped_at"
      type = "string"
    }
  }

  partition_keys {
    name = "observation_date"
    type = "string"
  }
}
