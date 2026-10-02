WITH daily_forecast_error AS (
    SELECT
        issue_date,
        valid_date,
        forecasted_high_temp_f,
        forecasted_low_temp_f,
        observed_high_temp_f,
        observed_low_temp_f,
        forecasted_high_temp_f - observed_high_temp_f AS high_temp_signed_error,
        forecasted_low_temp_f - observed_low_temp_f AS low_temp_signed_error,
        ABS(forecasted_high_temp_f - observed_high_temp_f)
            AS high_temp_abs_error,
        ABS(forecasted_low_temp_f - observed_low_temp_f) AS low_temp_abs_error
    FROM fct_daily_forecast_observation
),

error_metrics_by_lead_day AS (
    SELECT
        DATE_DIFF('day', issue_date, valid_date) AS lead_days,
        AVG(high_temp_signed_error) AS high_temp_bias,
        AVG(low_temp_signed_error) AS low_temp_bias,
        AVG(POWER(high_temp_signed_error, 2)) AS high_temp_mse,
        AVG(POWER(low_temp_signed_error, 2)) AS low_temp_mse,
        AVG(high_temp_abs_error) AS high_temp_mae,
        AVG(low_temp_abs_error) AS low_temp_mae,
        COUNT(*) AS number_of_samples
    FROM daily_forecast_error
    GROUP BY 1
)

SELECT
    *,
    SQRT(high_temp_mse) AS high_temp_rmse,
    SQRT(low_temp_mse) AS low_temp_rmse
FROM error_metrics_by_lead_day
WHERE lead_days > 0
