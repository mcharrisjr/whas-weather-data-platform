SELECT
    f.forecasted_temp_f,
    f.observed_temp_f,
    CAST(
        CONCAT(
            CAST(issue_date.calendar_date AS VARCHAR),
            ' ',
            CAST(issue_hour.time_of_day AS VARCHAR)
        ) AS TIMESTAMP
    ) AT TIME ZONE 'America/New_York' AS issued_at,
    CAST(
        CONCAT(
            CAST(valid_date.calendar_date AS VARCHAR),
            ' ',
            CAST(valid_hour.time_of_day AS VARCHAR)
        ) AS TIMESTAMP
    ) AT TIME ZONE 'America/New_York' AS valid_for,
    f.forecasted_temp_f - f.observed_temp_f AS signed_error,
    ABS(f.forecasted_temp_f - f.observed_temp_f) AS abs_error
FROM fct_hourly_forecast_observation AS f
LEFT JOIN dim_date AS issue_date
    ON f.issuance_date_key = issue_date.calendar_date_key
LEFT JOIN dim_date AS valid_date
    ON f.valid_date_key = valid_date.calendar_date_key
LEFT JOIN dim_time_hourly AS issue_hour
    ON f.issuance_hour_key = issue_hour.hour_key
LEFT JOIN dim_time_hourly AS valid_hour
    ON f.valid_hour_key = valid_hour.hour_key
