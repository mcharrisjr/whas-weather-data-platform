SELECT
    f.forecast_date,
    o.high_temperature_f - f.high_temperature_f AS bias_high_temperature_f,
    o.low_temperature_f - f.low_temperature_f AS bias_low_temperature_f,
    DATE_DIFF('day', CAST(f.scraped_at AS DATE), f.forecast_date)
        AS forecast_horizon_days
FROM {{ ref('stg_forecast_daily') }} AS f
INNER JOIN {{ ref('int_observation_daily') }} AS o
    ON f.forecast_date = o.observation_date
