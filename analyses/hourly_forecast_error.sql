SELECT
    forecasted_temp_f,
    observed_temp_f,
    issued_at AT TIME ZONE 'America/New_York' AS issued_at_et,
    valid_for AT TIME ZONE 'America/New_York' AS valid_for_et,
    forecasted_temp_f - observed_temp_f AS signed_error,
    ABS(forecasted_temp_f - observed_temp_f) AS abs_error
FROM fct_hourly_forecast_observation
