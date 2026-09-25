import datetime as dt
from unittest.mock import MagicMock
from zoneinfo import ZoneInfo

import pytest

from whas_weather_data_platform.core.enums import WeatherDataFrequency
from whas_weather_data_platform.core.models import (
    HourlyWeatherForecast,
    HourlyWeatherObservation,
)
from whas_weather_data_platform.core.s3_client import S3Client


def test_put_forecasts(monkeypatch: pytest.MonkeyPatch) -> None:
    eastern_tz = ZoneInfo("America/New_York")
    hourly_weather_forecasts = [
        HourlyWeatherForecast(
            forecasted_for=dt.datetime(2020, 1, 1, 0, tzinfo=eastern_tz),
            temperature_f=35,
            chance_of_precipitation=0.2,
            wind_speed_mph=2,
            wind_direction="N",
            scraped_at=dt.datetime(2019, 12, 31, 10, tzinfo=eastern_tz),
        ),
        HourlyWeatherForecast(
            forecasted_for=dt.datetime(2020, 1, 1, 1, tzinfo=eastern_tz),
            temperature_f=37,
            chance_of_precipitation=0.2,
            wind_speed_mph=3,
            wind_direction="N",
            scraped_at=dt.datetime(2019, 12, 31, 10, tzinfo=eastern_tz),
        ),
        HourlyWeatherForecast(
            forecasted_for=dt.datetime(2020, 1, 1, 2, tzinfo=eastern_tz),
            temperature_f=39,
            chance_of_precipitation=0.2,
            wind_speed_mph=3,
            wind_direction="N",
            scraped_at=dt.datetime(2019, 12, 31, 10, tzinfo=eastern_tz),
        ),
    ]

    mock_s3_client = MagicMock()

    s3_client = S3Client(s3_client=mock_s3_client)

    monkeypatch.setenv(
        "WHAS_WEATHER_RAW_GLUE_CATALOG_DATABASE",
        "whas_weather_data_platform_raw",
    )

    monkeypatch.setenv(
        "WHAS_WEATHER_RAW_S3_BUCKET",
        "whas-weather-data-platform-raw",
    )

    s3_client.put_forecasts(
        hourly_weather_forecasts, forecast_frequency=WeatherDataFrequency.HOURLY
    )

    _, kwargs = mock_s3_client.put_object.call_args

    assert kwargs["Bucket"] == "whas-weather-data-platform-raw"
    assert (
        "whas_weather_data_platform_raw_hourly_forecast/scraped_date=2019-12-31/forecast"
        in kwargs["Key"]
    )
    assert kwargs["ContentType"] == "application/x-ndjson"


def test_put_observation(monkeypatch: pytest.MonkeyPatch) -> None:
    eastern_tz = ZoneInfo("America/New_York")
    hourly_weather_observation = HourlyWeatherObservation(
        observed_at=dt.datetime(2020, 1, 1, 0, tzinfo=eastern_tz),
        temperature_f=35,
        feels_like_f=30,
        humidity=0.0,
        chance_of_precipitation=0.0,
        wind_speed_mph=3,
        wind_direction="N",
        condition_="Chilly",
        scraped_at=dt.datetime(2020, 1, 1, 0, 15, tzinfo=eastern_tz),
    )

    mock_s3_client = MagicMock()

    s3_client = S3Client(s3_client=mock_s3_client)

    monkeypatch.setenv(
        "WHAS_WEATHER_RAW_GLUE_CATALOG_DATABASE",
        "whas_weather_data_platform_raw",
    )

    monkeypatch.setenv(
        "WHAS_WEATHER_RAW_S3_BUCKET",
        "whas-weather-data-platform-raw",
    )

    s3_client.put_observation(
        hourly_weather_observation, observation_frequency=WeatherDataFrequency.HOURLY
    )

    _, kwargs = mock_s3_client.put_object.call_args

    assert kwargs["Bucket"] == "whas-weather-data-platform-raw"
    assert (
        "whas_weather_data_platform_raw_hourly_observation/observation_date=2020-01-01/observation"
        in kwargs["Key"]
    )
    assert kwargs["ContentType"] == "application/x-ndjson"
