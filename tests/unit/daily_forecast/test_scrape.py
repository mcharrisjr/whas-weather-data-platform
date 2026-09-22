from unittest.mock import MagicMock, patch

from bs4 import Tag

import whas_weather_data_platform.daily_forecast.scrape as scrape_module
from whas_weather_data_platform.core.enums import WeatherDataFrequency
from whas_weather_data_platform.core.s3_client import S3Client
from whas_weather_data_platform.daily_forecast.scrape import scrape


def test_scrape(weather_soup: Tag) -> None:
    mock_s3_client = MagicMock()

    s3_client = S3Client(s3_client=mock_s3_client)

    with (
        patch.object(
            scrape_module, "parse_daily_weather_forecasts", autospec=True
        ) as mock_parse,
        patch.object(
            scrape_module.S3Client, "put_forecasts", autospec=True
        ) as mock_put_forecasts,
    ):
        scrape(str(weather_soup), s3_client=s3_client)

        mock_parse.assert_called_once_with(str(weather_soup))
        mock_put_forecasts.assert_called_once_with(
            s3_client,
            mock_parse.return_value,
            forecast_frequency=WeatherDataFrequency.DAILY,
        )
