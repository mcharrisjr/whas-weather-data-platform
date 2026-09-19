from whas_weather_data_platform.core.enums import WeatherDataFrequency
from whas_weather_data_platform.core.s3_client import S3Client
from whas_weather_data_platform.observation_hourly.parse import (
    parse_hourly_weather_observation,
)


def scrape(html: str, *, s3_client: S3Client) -> None:
    hourly_weather_observation = parse_hourly_weather_observation(html)
    s3_client.put_observation(
        hourly_weather_observation, observation_frequency=WeatherDataFrequency.HOURLY
    )
