SELECT
    f.forecasted_temp_f,
    f.observed_temp_f,
    f.issued_at AT TIME ZONE 'America/New_York' AS issued_at_et,
    f.valid_for AT TIME ZONE 'America/New_York' AS valid_for_et,
    f.forecasted_temp_f - f.observed_temp_f AS signed_error,
    ABS(f.forecasted_temp_f - f.observed_temp_f) AS abs_error
FROM fct_hourly_forecast_observation AS f
