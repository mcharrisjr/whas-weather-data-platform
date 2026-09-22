import datetime as dt
from typing import cast
from unittest.mock import patch
from zoneinfo import ZoneInfo

import pytest
from bs4 import Tag

import whas_weather_data_platform.daily_forecast.parse as parse_module
from whas_weather_data_platform.core.models import DailyWeatherForecast
from whas_weather_data_platform.daily_forecast.parse import (
    _parse_chance_of_precipitation,
    _parse_forecast_date,
    _parse_high_temperature,
    _parse_low_temperature,
    _parse_wind_direction,
    _parse_wind_speed,
    parse_daily_weather_forecasts,
)


class MutableDateTime(dt.datetime):
    pass


@pytest.fixture(scope="module")
def weather_row(weather_soup: Tag) -> Tag:
    return cast("Tag", weather_soup.find("div", class_="weather-10-day__row"))


def test_parse_daily_weather_forecasts(weather_soup: Tag) -> None:
    eastern_tz = ZoneInfo("America/New_York")
    expected = DailyWeatherForecast(
        forecast_date=dt.date(2026, 9, 21),
        high_temperature_f=87,
        low_temperature_f=63,
        chance_of_precipitation=0.3,
        wind_speed_mph=11,
        wind_direction="NNE",
        scraped_at=dt.datetime(2026, 9, 21, 10, tzinfo=eastern_tz),
    )

    with (
        patch.object(parse_module.dt, "datetime", MutableDateTime),
        patch.object(
            MutableDateTime,
            "now",
            autospec=True,
            return_value=dt.datetime(2026, 9, 21, 10, tzinfo=eastern_tz),
        ) as mock_now,
    ):
        actual = parse_daily_weather_forecasts(str(weather_soup))

        mock_now.assert_called_once_with(tz=eastern_tz)

    assert len(actual) == 10
    assert actual[0] == expected


def test_parse_forecast_date(weather_row: Tag) -> None:
    expected = dt.date(2026, 9, 21)
    actual = _parse_forecast_date(weather_row, current_year=2026)

    assert actual == expected


def test_parse_high_temperature(weather_row: Tag) -> None:
    expected = 87
    actual = _parse_high_temperature(weather_row)

    assert actual == expected


def test_parse_low_temperature(weather_row: Tag) -> None:
    expected = 63
    actual = _parse_low_temperature(weather_row)

    assert actual == expected


def test_parse_chance_of_precipitation(weather_row: Tag) -> None:
    expected = 0.3
    actual = _parse_chance_of_precipitation(weather_row)

    assert actual == expected


def test_parse_wind_speed(weather_row: Tag) -> None:
    expected = 11
    actual = _parse_wind_speed(weather_row)

    assert actual == expected


def test_parse_wind_direction(weather_row: Tag) -> None:
    expected = "NNE"
    actual = _parse_wind_direction(weather_row)

    assert actual == expected
