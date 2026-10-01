WITH daily_observation AS (
    SELECT
        CAST(observed_at AS DATE) AS observation_date,
        MAX(temperature_f) AS high_temperature_f,
        MIN(temperature_f) AS low_temperature_f
    FROM {{ ref('stg_hourly_observation') }}
    GROUP BY 1
)

SELECT
    CAST(FORMAT_DATETIME(f.forecast_date, 'yyyyMMdd') AS INT)
        AS calendar_date_key,
    f.scraped_date AS issue_date,
    f.forecast_date AS valid_date,
    f.high_temperature_f AS forecasted_high_temp_f,
    o.high_temperature_f AS observed_high_temp_f,
    f.low_temperature_f AS forecasted_low_temp_f,
    o.low_temperature_f AS observed_low_temp_f
FROM {{ ref('stg_daily_forecast') }} AS f
INNER JOIN daily_observation AS o
    ON f.forecast_date = o.observation_date
