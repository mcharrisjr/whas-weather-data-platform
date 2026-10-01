WITH time_spine AS (
    SELECT t.time_raw
    FROM
        UNNEST(
            SEQUENCE(
                CAST('2026-01-01 00:00:00' AS TIMESTAMP),
                CAST('2026-01-01 23:00:00' AS TIMESTAMP),
                INTERVAL '1' HOUR
            )
        ) AS t (time_raw)
),

final AS (
    SELECT
        CAST(time_raw AS TIME) AS time_of_day,
        EXTRACT(HOUR FROM time_raw) AS hour_key,
        EXTRACT(HOUR FROM time_raw) AS hour_24,
        CASE
            WHEN EXTRACT(HOUR FROM time_raw) BETWEEN 11 AND 17 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM time_raw) BETWEEN 18 AND 22 THEN 'Afternoon'
            WHEN EXTRACT(HOUR FROM time_raw) IN (23, 0, 1, 2, 3) THEN 'Evening'
            ELSE 'Night'
        END AS part_of_day
    FROM time_spine
)

SELECT *
FROM final
