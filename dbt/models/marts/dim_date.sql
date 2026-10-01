WITH date_spine AS (
    SELECT calendar_date
    FROM (
        SELECT calendar_date
        FROM UNNEST(
            SEQUENCE(
                DATE '2026-01-01',
                DATE '2030-01-01',
                INTERVAL '1' DAY
            )
        )
    ) AS t
),

final AS (
    SELECT
        CAST(FORMAT_DATETIME(calendar_date, 'yyyyMMdd') AS INT)
            AS calendar_date_key,
        calendar_date,
        EXTRACT(YEAR FROM calendar_date) AS calendar_year,
        EXTRACT(MONTH FROM calendar_date) AS calendar_month,
        FORMAT_DATETIME(calendar_date, 'MMMM') AS calendar_month_name,
        FORMAT_DATETIME(calendar_date, 'MMM') AS calendar_month_name_short,
        CASE
            WHEN EXTRACT(MONTH FROM calendar_date) IN (12, 1, 2) THEN 'Winter'
            WHEN EXTRACT(MONTH FROM calendar_date) BETWEEN 3 AND 5 THEN 'Spring'
            WHEN EXTRACT(MONTH FROM calendar_date) BETWEEN 6 AND 8 THEN 'Summer'
            ELSE 'Fall'
        END AS season
    FROM date_spine
)

SELECT *
FROM final
