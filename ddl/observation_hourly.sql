CREATE EXTERNAL TABLE IF NOT EXISTS weather_raw.observation_hourly (
    observed_at TIMESTAMP,
    temperature_f INTEGER,
    feels_like_f INTEGER,
    humidity DOUBLE,
    chance_of_precipitation DOUBLE,
    wind_speed_mph TINYINT,
    wind_direction STRING,
    condition_ STRING,
    scraped_at TIMESTAMP
)
PARTITIONED BY (scraped_date DATE)
ROW FORMAT SERDE 'org.openx.jsonserde.JsonSerDe'
STORED AS TEXTFILE
LOCATION 's3://whas-weather-data-platform-raw/weather-raw/observation-hourly/'
