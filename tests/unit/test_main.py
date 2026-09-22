import sys
from unittest.mock import patch

import aiohttp
import pytest

import whas_weather_data_platform.hourly_forecast.scrape as scrape_module
import whas_weather_data_platform.main as main_module
from whas_weather_data_platform.core.enums import WeatherDataFrequency, WeatherDataType
from whas_weather_data_platform.main import main, parse_args


@pytest.mark.parametrize(
    ("argv", "expected_type", "expected_frequency", "expected_url"),
    [
        pytest.param(
            ["placeholder.py"],
            WeatherDataType.OBSERVATION,
            WeatherDataFrequency.HOURLY,
            "https://www.whas11.com/",
            id="default",
        ),
        pytest.param(
            ["placeholder.py", "-t", "forecast", "-f", "daily"],
            WeatherDataType.FORECAST,
            WeatherDataFrequency.DAILY,
            "https://www.whas11.com/",
            id="custom",
        ),
    ],
)
def test_parse_args(
    argv: list[str],
    expected_type: WeatherDataType,
    expected_frequency: WeatherDataFrequency,
    expected_url: str,
) -> None:
    with patch.object(sys, "argv", argv):
        args = parse_args()

        assert args.type is expected_type
        assert args.frequency is expected_frequency
        assert args.url == expected_url


async def test_main() -> None:
    with (
        patch.object(sys, "argv", ["placeholder.py", "-t", "forecast", "-f", "hourly"]),
        patch.object(main_module, "WHASClient", autospec=True) as mock_whas_client_cls,
        patch.object(main_module, "boto3", autospec=True) as mock_boto3_module,
        patch.object(main_module, "S3Client", autospec=True) as mock_s3_client_cls,
        patch.object(scrape_module, "scrape", autospec=True) as mock_scrape,
        patch.dict(main_module.SCRAPER_REGISTRY, {(WeatherDataType.FORECAST, WeatherDataFrequency.HOURLY): mock_scrape}),
    ):
        mock_whas_client = mock_whas_client_cls.return_value

        mock_boto3_session = mock_boto3_module.Session.return_value

        result = await main()

        mock_whas_client.weather_page.assert_awaited_once()

        mock_boto3_module.Session.assert_called_once()

        mock_boto3_session.client.assert_called_once_with("s3")
        mock_s3_client_cls.assert_called_once_with(
            s3_client=mock_boto3_session.client.return_value
        )

        mock_scrape.assert_called_once_with(
            mock_whas_client.weather_page.return_value,
            s3_client=mock_s3_client_cls.return_value,
        )

        assert result == 0
