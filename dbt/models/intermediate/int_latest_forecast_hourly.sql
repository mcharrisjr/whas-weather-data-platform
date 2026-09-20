WITH ranked_forecast_hourly AS (
    SELECT
        forecasted_for,
        temperature_f,
        chance_of_precipitation,
        wind_speed_mph,
        wind_direction,
        ROW_NUMBER() OVER (
            PARTITION BY forecasted_for
            ORDER BY scraped_at DESC
        ) AS rn
    FROM {{ ref('stg_forecast_hourly') }}
)

SELECT
    forecasted_for,
    temperature_f,
    chance_of_precipitation,
    wind_speed_mph,
    wind_direction
FROM ranked_forecast_hourly
WHERE rn = 1
