SELECT
    f.forecasted_at,
    o.temperature_f - f.temperature_f AS bias_temperature_f,
    DATE_DIFF('hour', f.scraped_at, f.forecasted_at) AS forecast_horizon_hours
FROM {{ ref('stg_hourly_forecast') }} AS f
INNER JOIN {{ ref('int_hourly_observation') }} AS o
    ON f.forecasted_at = o.observed_at
