import datetime as dt
from typing import cast
from unittest.mock import patch
from zoneinfo import ZoneInfo

import pytest
from bs4 import Tag

import whas_weather_data_platform.hourly_forecast.parse as parse_module
from whas_weather_data_platform.core.models import HourlyWeatherForecast
from whas_weather_data_platform.hourly_forecast.parse import (
    _parse_chance_of_precipitation,
    _parse_forecasted_for,
    _parse_temperature,
    _parse_wind_direction,
    _parse_wind_speed,
    parse_hourly_weather_forecasts,
)


class MutableDateTime(dt.datetime):
    pass


@pytest.fixture(scope="module")
def weather_row(weather_soup: Tag) -> Tag:
    return cast("Tag", weather_soup.find("div", class_="weather-hourly__row"))


def test_parse_hourly_weather_forecasts(weather_soup: Tag) -> None:
    utc_tz = ZoneInfo("UTC")
    expected = HourlyWeatherForecast(
        forecasted_for=dt.datetime(2026, 9, 21, 17, tzinfo=utc_tz),
        temperature_f=84,
        chance_of_precipitation=0.15,
        wind_speed_mph=3,
        wind_direction="NNE",
        scraped_at=dt.datetime(2026, 9, 21, 12, tzinfo=utc_tz),
    )

    with (
        patch.object(parse_module.dt, "datetime", MutableDateTime),
        patch.object(
            MutableDateTime,
            "now",
            autospec=True,
            return_value=dt.datetime(2026, 9, 21, 12, tzinfo=utc_tz),
        ) as mock_now,
    ):
        actual = parse_hourly_weather_forecasts(str(weather_soup))

        mock_now.assert_called_once_with(tz=utc_tz)

    assert len(actual) == 12
    assert actual[0] == expected


def test_parse_forecasted_for(weather_row: Tag) -> None:
    expected = dt.datetime(2026, 9, 21, 17, tzinfo=ZoneInfo("UTC"))
    actual = _parse_forecasted_for(weather_row, current_date=dt.date(2026, 9, 21))

    assert actual == expected


def test_parse_temperature(weather_row: Tag) -> None:
    expected = 84
    actual = _parse_temperature(weather_row)

    assert actual == expected


def test_parse_chance_of_precipitation(weather_row: Tag) -> None:
    expected = 0.15
    actual = _parse_chance_of_precipitation(weather_row)

    assert actual == expected


def test_parse_wind_speed(weather_row: Tag) -> None:
    expected = 3
    actual = _parse_wind_speed(weather_row)

    assert actual == expected


def test_parse_wind_direction(weather_row: Tag) -> None:
    expected = "NNE"
    actual = _parse_wind_direction(weather_row)

    assert actual == expected
