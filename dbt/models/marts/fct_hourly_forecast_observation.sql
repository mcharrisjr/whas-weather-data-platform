SELECT
    CAST(FORMAT_DATETIME(f.forecasted_for, 'yyyyMMdd') AS INT)
        AS calendar_date_key,
    f.forecasted_for,
    o.observed_at,
    f.temperature_f AS forecasted_temp_f,
    o.temperature_f AS observed_temp_f,
    EXTRACT(HOUR FROM f.forecasted_for) AS hour_key
FROM {{ ref('stg_hourly_forecast') }} AS f
LEFT JOIN {{ ref('stg_hourly_observation') }} AS o
    ON f.forecasted_for = o.observed_at
