SELECT
    temperature_f,
    feels_like_f,
    humidity,
    chance_of_precipitation,
    wind_speed_mph,
    wind_direction,
    condition_,
    scraped_at,
    DATE_TRUNC('hour', observed_at) AS observed_at
FROM {{ ref('stg_hourly_observation') }}
