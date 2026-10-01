SELECT
    issue_date.calendar_date AS issuance_date,
    valid_date.calendar_date AS valid_date,
    f.forecasted_high_temp_f,
    f.forecasted_low_temp_f,
    f.observed_high_temp_f,
    f.observed_low_temp_f,
    f.forecasted_high_temp_f - f.observed_high_temp_f AS high_temp_signed_error,
    f.forecasted_low_temp_f - f.observed_low_temp_f AS low_temp_signed_error,
    ABS(f.forecasted_high_temp_f - f.observed_high_temp_f)
        AS high_temp_abs_error,
    ABS(f.forecasted_low_temp_f - f.observed_low_temp_f) AS low_temp_abs_error
FROM fct_daily_forecast_observation AS f
LEFT JOIN dim_date AS issue_date
    ON f.issuance_date_key = issue_date.calendar_date_key
LEFT JOIN dim_date AS valid_date
    ON f.valid_date_key = valid_date.calendar_date_key
