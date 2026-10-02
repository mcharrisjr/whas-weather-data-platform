WITH deduplicated_hourly_observation AS (
    SELECT
        valid_for AT TIME ZONE 'America/New_York' AS observed_at,
        MAX_BY(valid_hour_key, valid_for) AS valid_hour_key,
        MAX_BY(observed_temp_f, valid_for) AS observed_temp_f
    FROM fct_hourly_forecast_observation
    GROUP BY valid_for
),

hourly_observation_with_temp_change AS (
    SELECT
        valid_hour_key,
        observed_at,
        observed_temp_f,
        observed_temp_f - LAG(observed_temp_f) OVER (ORDER BY observed_at) AS temp_change
    FROM deduplicated_hourly_observation
)

SELECT
    d.hour_24,
    AVG(o.temp_change) AS avg_temp_change,
    MAX(o.temp_change) AS max_temp_change,
    MIN(o.temp_change) AS min_temp_change,
    COUNT(*) AS number_of_samples
FROM hourly_observation_with_temp_change AS o
LEFT JOIN dim_time_hourly AS d
    ON o.valid_hour_key = d.hour_key
GROUP BY d.hour_24
