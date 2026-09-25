SELECT
    CAST(temperature_f AS INTEGER) AS temperature_f,
    CAST(chance_of_precipitation AS DOUBLE) AS chance_of_precipitation,
    CAST(wind_speed_mph AS INTEGER) AS wind_speed_mph,
    wind_direction,
    DATE_PARSE(forecasted_for, '%Y-%m-%d %H:%i:%s') AS forecasted_for_local,
    DATE_PARSE(scraped_at, '%Y-%m-%d %H:%i:%s') AS scraped_at
FROM {{ source('raw', 'hourly_forecast') }}
