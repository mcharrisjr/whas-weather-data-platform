{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='observed_at'
    )
}}

SELECT
    temperature_f,
    feels_like_f,
    humidity,
    chance_of_precipitation,
    wind_speed_mph,
    wind_direction,
    condition_,
    scraped_at,
    DATE_TRUNC('hour', observed_at) AS observed_at
FROM {{ ref('stg_hourly_observation') }}

{% if is_incremental() %}
    WHERE scraped_at > (SELECT MAX(scraped_at) FROM {{ this }}) -- noqa: RF02
{% endif %}
