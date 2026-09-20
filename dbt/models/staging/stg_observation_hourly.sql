SELECT
    CAST(observed_at AS TIMESTAMP) AS observed_at,
    CAST(temperature_f AS INTEGER) AS temperature_f,
    CAST(feels_like_f AS INTEGER) AS feels_like_f,
    CAST(humidity AS DOUBLE) AS humidity,
    CAST(chance_of_precipitation AS DOUBLE) AS chance_of_precipitation,
    CAST(wind_speed_mph AS TINYINT) AS wind_speed_mph,
    wind_direction,
    condition_,
    CAST(scraped_at AS TIMESTAMP) AS scraped_at
FROM {{ source('weather_raw', 'observation_hourly') }}
