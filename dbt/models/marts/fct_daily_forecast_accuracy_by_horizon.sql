SELECT
    forecast_horizon_days,
    AVG(residual_high_temperature_f) AS avg_residual_high_temperature_f,
    MAX(residual_high_temperature_f) AS max_residual_high_temperature_f,
    AVG(residual_low_temperature_f) AS avg_residual_low_temperature_f,
    MAX(residual_low_temperature_f) AS max_residual_low_temperature_f,
    AVG(abs_error_high_temperature_f) AS avg_abs_error_high_temperature_f,
    MAX(abs_error_high_temperature_f) AS max_abs_error_high_temperature_f,
    AVG(abs_error_low_temperature_f) AS avg_abs_error_low_temperature_f,
    MAX(abs_error_low_temperature_f) AS max_abs_error_low_temperature_f,
    COUNT(*) AS number_of_samples
FROM {{ ref('int_daily_forecast_accuracy') }}
WHERE forecast_horizon_days > 0
GROUP BY forecast_horizon_days
