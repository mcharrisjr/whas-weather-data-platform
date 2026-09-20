SELECT
    CAST(forecasted_for AS TIMESTAMP) AS forecasted_for,
    CAST(temperature_f AS INTEGER) AS temperature_f,
    CAST(chance_of_precipitation AS DOUBLE) AS chance_of_precipitation,
    CAST(wind_speed_mph AS TINYINT) AS wind_speed_mph,
    wind_direction,
    CAST(scraped_at AS TIMESTAMP) AS scraped_at
FROM {{ source('weather_raw', 'forecast_hourly') }}
