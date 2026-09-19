import os
from collections.abc import Sequence
from typing import ClassVar

from types_boto3_s3 import S3Client as S3Client_

from whas_weather_data_platform.core.enums import WeatherDataFrequency, WeatherDataType
from whas_weather_data_platform.core.models import (
    HourlyWeatherObservation,
    ScrapedWeather,
)


class S3Client:
    """AWS S3 client.

    Attributes:
        _WEATHER_DATA_RAW_S3_KEY_PREFIX (ClassVar[str]): Raw weather data S3 object key prefix.
        _s3_client (object): boto3 S3 client.
    """

    _WEATHER_DATA_RAW_S3_KEY_PREFIX: ClassVar[str] = "weather_raw"

    def __init__(self, *, s3_client: S3Client_) -> None:
        self._s3_client = s3_client

    def put_forecasts(
        self,
        weather_forecasts: Sequence[ScrapedWeather],
        *,
        forecast_frequency: WeatherDataFrequency,
    ) -> None:
        """Put weather forecast objects into S3 bucket.

        Args:
            weather_forecasts: Weather forecasts.
            forecast_frequency: Forecast frequency.
        """
        scraped_dates = {forecast.scraped_at.date() for forecast in weather_forecasts}
        (scraped_date,) = scraped_dates

        ndjson = "\n".join(forecast.model_dump_json() for forecast in weather_forecasts)

        s3_object_key = (
            f"{self._WEATHER_DATA_RAW_S3_KEY_PREFIX}/"
            f"{WeatherDataType.FORECAST}_{forecast_frequency}/"
            f"scraped_date={scraped_date.isoformat()}/"
            f"{WeatherDataType.FORECAST}.ndjson"
        )

        self._s3_client.put_object(
            Bucket=os.environ["WEATHER_RAW_S3_BUCKET"],
            Key=s3_object_key,
            Body=ndjson.encode("utf-8"),
            ContentType="application/x-ndjson",
        )

    def put_observation(
        self,
        weather_observation: HourlyWeatherObservation,
        *,
        observation_frequency: WeatherDataFrequency,
    ) -> None:
        """Put weather observation into S3 bucket.

        Args:
            weather_observation: Weather observation.
            observation_frequency: Observation frequency.
        """
        observed_date = weather_observation.observed_at.date()

        ndjson = weather_observation.model_dump_json()

        s3_object_key = (
            f"{self._WEATHER_DATA_RAW_S3_KEY_PREFIX}/"
            f"{WeatherDataType.OBSERVATION}_{observation_frequency}/"
            f"observed_date={observed_date.isoformat()}/"
            f"{WeatherDataType.OBSERVATION}.ndjson"
        )

        self._s3_client.put_object(
            Bucket=os.environ["WEATHER_RAW_S3_BUCKET"],
            Key=s3_object_key,
            Body=ndjson.encode("utf-8"),
            ContentType="application/x-ndjson",
        )
