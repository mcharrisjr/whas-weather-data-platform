SELECT
    forecast_date,
    high_temperature_f - low_temperature_f AS temperature_spread_f
FROM {{ ref("stg_daily_forecasts") }}
