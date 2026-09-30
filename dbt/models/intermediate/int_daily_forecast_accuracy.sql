SELECT
    f.forecast_date,
    o.high_temperature_f - f.high_temperature_f AS residual_high_temperature_f,
    ABS(o.high_temperature_f - f.high_temperature_f)
        AS abs_error_high_temperature_f,
    o.low_temperature_f - f.low_temperature_f AS residual_low_temperature_f,
    ABS(o.low_temperature_f - f.low_temperature_f)
        AS abs_error_low_temperature_f,
    DATE_DIFF(
        'day',
        f.scraped_date,
        f.forecast_date
    )
        AS forecast_horizon_days
FROM {{ ref('stg_daily_forecast') }} AS f
INNER JOIN {{ ref('int_daily_observation') }} AS o
    ON f.forecast_date = o.observation_date
