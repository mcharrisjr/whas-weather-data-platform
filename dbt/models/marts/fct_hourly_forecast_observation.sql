SELECT
    CAST(FORMAT_DATETIME(f.scraped_at, 'yyyyMMdd') AS INT) AS issuance_date_key,
    CAST(FORMAT_DATETIME(f.forecasted_for, 'yyyyMMdd') AS INT)
        AS valid_date_key,
    f.scraped_at AS issued_at,
    f.forecasted_for AS valid_for,
    f.temperature_f AS forecasted_temp_f,
    o.temperature_f AS observed_temp_f,
    EXTRACT(HOUR FROM f.scraped_at) AS issuance_hour_key,
    EXTRACT(HOUR FROM f.forecasted_for) AS valid_hour_key
FROM {{ ref('stg_hourly_forecast') }} AS f
INNER JOIN {{ ref('stg_hourly_observation') }} AS o
    ON f.forecasted_for = o.observed_at
