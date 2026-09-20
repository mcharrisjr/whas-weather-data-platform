SELECT
    f.forecasted_at,
    o.temperature_f - f.temperature_f AS bias_temperature_f,
    DATE_DIFF('hour', f.scraped_at, f.forecasted_at) AS forecast_horizon_hours
FROM {{ ref('stg_forecast_hourly') }} AS f
INNER JOIN {{ ref('int_observation_hourly') }} AS o
    ON f.forecasted_at = o.observed_at
