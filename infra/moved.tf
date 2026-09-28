moved {
  from = aws_glue_catalog_database.raw
  to   = aws_glue_catalog_database.databases["raw"]
}

moved {
  from = aws_glue_catalog_database.staging
  to   = aws_glue_catalog_database.databases["staging"]
}

moved {
  from = aws_glue_catalog_database.intermediate
  to   = aws_glue_catalog_database.databases["intermediate"]
}

moved {
  from = aws_glue_catalog_database.mart
  to   = aws_glue_catalog_database.databases["mart"]
}

moved {
  from = aws_glue_catalog_table.raw_hourly_forecast
  to   = aws_glue_catalog_table.tables["raw_hourly_forecast"]
}

moved {
  from = aws_glue_catalog_table.raw_daily_forecast
  to   = aws_glue_catalog_table.tables["raw_daily_forecast"]
}

moved {
  from = aws_glue_catalog_table.raw_hourly_observation
  to   = aws_glue_catalog_table.tables["raw_hourly_observation"]
}
