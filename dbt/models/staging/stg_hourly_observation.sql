SELECT
    CAST(temperature_f AS INTEGER) AS temperature_f,
    CAST(feels_like_f AS INTEGER) AS feels_like_f,
    CAST(humidity AS DOUBLE) AS humidity,
    CAST(chance_of_precipitation AS DOUBLE) AS chance_of_precipitation,
    CAST(wind_speed_mph AS INTEGER) AS wind_speed_mph,
    wind_direction,
    condition_,
    CAST(FROM_ISO8601_TIMESTAMP(observed_at) AS TIMESTAMP) AS observed_at,
    CAST(FROM_ISO8601_TIMESTAMP(scraped_at) AS TIMESTAMP) AS scraped_at
FROM {{ source('raw', 'hourly_observation') }}
