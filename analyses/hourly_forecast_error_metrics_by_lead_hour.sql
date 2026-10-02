WITH hourly_forecast_error AS (
    SELECT
        issued_at,
        valid_for,
        forecasted_temp_f,
        observed_temp_f,
        forecasted_temp_f - observed_temp_f AS signed_error,
        ABS(forecasted_temp_f - observed_temp_f) AS abs_error
    FROM fct_hourly_forecast_observation
),

error_metrics_by_lead_hour AS (
    SELECT
        DATE_DIFF('hour', issued_at, valid_for) AS lead_hours,
        AVG(signed_error) AS bias,
        AVG(POWER(signed_error, 2)) AS mse,
        AVG(abs_error) AS mae
    FROM hourly_forecast_error
    GROUP BY 1
)

SELECT
    *,
    SQRT(mse) AS rmse
FROM error_metrics_by_lead_hour
WHERE lead_hours > 0
