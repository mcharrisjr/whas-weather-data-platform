SELECT
    CAST(
        FROM_ISO8601_TIMESTAMP(
            forecasted_for
        ) AT TIME ZONE 'America/New_York' AS TIMESTAMP
    ) AS forecasted_for_local,
    CAST(temperature_f AS INTEGER) AS temperature_f,
    CAST(chance_of_precipitation AS DOUBLE) AS chance_of_precipitation,
    CAST(wind_speed_mph AS INTEGER) AS wind_speed_mph,
    wind_direction,
    CAST(FROM_ISO8601_TIMESTAMP(scraped_at) AS TIMESTAMP) AS scraped_at
FROM {{ source('raw', 'hourly_forecast') }}
