SELECT
    forecast_horizon_hours,
    AVG(residual_temperature_f) AS avg_residual_temperature_f,
    MAX(residual_temperature_f) AS max_residual_temperature_f,
    AVG(abs_error_temperature_f) AS avg_abs_error_temperature_f,
    MAX(abs_error_temperature_f) AS max_abs_error_temperature_f,
    COUNT(*) AS number_of_samples
FROM {{ ref('int_hourly_forecast_accuracy') }}
WHERE forecast_horizon_hours > 0
GROUP BY forecast_horizon_hours
