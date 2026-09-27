SELECT
    CAST(observed_at AS DATE) AS observation_date,
    MAX(temperature_f) AS high_temperature_f,
    MIN(temperature_f) AS low_temperature_f
FROM {{ ref('stg_hourly_observation') }}
GROUP BY 1
