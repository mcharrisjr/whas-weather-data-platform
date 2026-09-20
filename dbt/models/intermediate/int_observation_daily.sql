SELECT
    observation_date,
    MAX(temperature_f)
        OVER (PARTITION BY observation_date)
        AS high_temperature_f,
    MIN(temperature_f) OVER (PARTITION BY observation_date) AS low_temperature_f
FROM (
    SELECT
        CAST(observed_at AS DATE) AS observation_date,
        temperature_f
    FROM {{ ref('stg_observation_hourly') }}
)
