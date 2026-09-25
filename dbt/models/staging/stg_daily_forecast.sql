SELECT
    CAST(forecast_date AS DATE) AS forecast_date,
    CAST(high_temperature_f AS INTEGER) AS high_temperature_f,
    CAST(low_temperature_f AS INTEGER) AS low_temperature_f,
    CAST(chance_of_precipitation AS DOUBLE) AS chance_of_precipitation,
    CAST(wind_speed_mph AS INTEGER) AS wind_speed_mph,
    wind_direction,
    DATE_PARSE(scraped_at, '%Y-%m-%d %H:%i:%s') AS scraped_at
FROM {{ source('raw', 'daily_forecast') }}
