from whas_weather_data_platform.core.enums import WeatherDataFrequency
from whas_weather_data_platform.core.s3_client import S3Client
from whas_weather_data_platform.daily_forecast.parse import (
    parse_daily_weather_forecasts,
)


def scrape(html: str, *, s3_client: S3Client) -> None:
    daily_weather_forecasts = parse_daily_weather_forecasts(html)
    s3_client.put_forecasts(
        daily_weather_forecasts, forecast_frequency=WeatherDataFrequency.DAILY
    )
