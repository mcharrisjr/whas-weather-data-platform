SELECT
    f.forecasted_for_local,
    o.temperature_f - f.temperature_f AS bias_temperature_f,
    DATE_DIFF(
        'hour',
        CAST(f.scraped_at AT TIME ZONE 'America/New_York' AS TIMESTAMP),
        f.forecasted_for_local
    ) AS forecast_horizon_hours
FROM {{ ref('stg_hourly_forecast') }} AS f
INNER JOIN {{ ref('int_hourly_observation') }} AS o
    ON f.forecasted_for_local = o.observed_at_local
