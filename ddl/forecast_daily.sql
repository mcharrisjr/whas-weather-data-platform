CREATE EXTERNAL TABLE IF NOT EXISTS weather_raw.forecast_daily (
    forecast_date DATE,
    high_temperature_f INTEGER,
    low_temperature_f INTEGER,
    chance_of_precipitation DOUBLE,
    wind_speed_mph TINYINT,
    wind_direction STRING,
    scraped_at TIMESTAMP
)
PARTITIONED BY (scraped_date DATE)
ROW FORMAT SERDE 'org.openx.jsonserde.JsonSerDe'
STORED AS TEXTFILE
LOCATION 's3://whas-weather-data-platform-raw/weather-raw/forecast-daily/'
