WITH hourly_forecast_error AS (
    SELECT
        forecasted_temp_f,
        observed_temp_f,
        issued_at AT TIME ZONE 'America/New_York' AS issued_at_et,
        valid_for AT TIME ZONE 'America/New_York' AS valid_for_et,
        forecasted_temp_f - observed_temp_f AS signed_error,
        ABS(forecasted_temp_f - observed_temp_f) AS abs_error
    FROM fct_hourly_forecast_observation
),

error_metrics_by_lead_hour AS (
    SELECT
        DATE_DIFF('hour', issued_at_et, valid_for_et) AS lead_hours,
        AVG(signed_error) AS temp_bias,
        AVG(POWER(signed_error, 2)) AS temp_mse,
        AVG(abs_error) AS temp_mae,
        COUNT(*) AS number_of_samples
    FROM hourly_forecast_error
    GROUP BY 1
)

SELECT
    *,
    SQRT(temp_mse) AS temp_rmse
FROM error_metrics_by_lead_hour
WHERE lead_hours > 0
