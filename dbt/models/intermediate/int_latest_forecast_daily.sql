WITH ranked_forecast_daily AS (
    SELECT
        forecast_date,
        high_temperature_f,
        low_temperature_f,
        chance_of_precipitation,
        wind_speed_mph,
        wind_direction,
        ROW_NUMBER() OVER (
            PARTITION BY forecast_date
            ORDER BY scraped_at DESC
        ) AS rn
    FROM {{ ref('stg_forecast_daily') }}
)

SELECT
    forecast_date,
    high_temperature_f,
    low_temperature_f,
    chance_of_precipitation,
    wind_speed_mph,
    wind_direction
FROM ranked_forecast_daily
WHERE rn = 1
