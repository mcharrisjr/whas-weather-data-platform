SELECT
    f.forecasted_for,
    o.temperature_f - f.temperature_f AS residual_temperature_f,
    ABS(o.temperature_f - f.temperature_f) AS abs_error_temperature_f,
    DATE_DIFF(
        'hour',
        f.scraped_at,
        f.forecasted_for
    ) AS forecast_horizon_hours
FROM {{ ref('stg_hourly_forecast') }} AS f
INNER JOIN {{ ref('stg_hourly_observation') }} AS o
    ON f.forecasted_for = o.observed_at
