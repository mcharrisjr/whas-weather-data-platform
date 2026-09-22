import datetime as dt
from unittest.mock import patch
from zoneinfo import ZoneInfo

from bs4 import Tag

import whas_weather_data_platform.hourly_observation.parse as parse_module
from whas_weather_data_platform.core.models import HourlyWeatherObservation
from whas_weather_data_platform.hourly_observation.parse import (
    _parse_chance_of_precipitation,
    _parse_condition,
    _parse_feels_like,
    _parse_humidity,
    _parse_temperature,
    _parse_wind,
    parse_hourly_weather_observation,
)


class MutableDateTime(dt.datetime):
    pass


def test_parse_hourly_weather_observation(weather_soup: Tag) -> None:
    eastern_tz = ZoneInfo("America/New_York")
    expected = HourlyWeatherObservation(
        observed_at=dt.datetime(2026, 9, 21, 12, tzinfo=eastern_tz),
        temperature_f=84,
        feels_like_f=87,
        humidity=0.57,
        chance_of_precipitation=0.0,
        wind_speed_mph=3,
        wind_direction="NE",
        condition_="Fair",
        scraped_at=dt.datetime(2026, 9, 21, 12, tzinfo=eastern_tz),
    )

    with (
        patch.object(parse_module.dt, "datetime", MutableDateTime),
        patch.object(MutableDateTime, "now", return_value=dt.datetime(2026, 9, 21, 12, tzinfo=eastern_tz)),
    ):
        actual = parse_hourly_weather_observation(str(weather_soup))

        assert actual == expected


def test_parse_temperature(weather_soup: Tag) -> None:
    expected = 84
    actual = _parse_temperature(weather_soup)

    assert actual == expected


def test_parse_feels_like(weather_soup: Tag) -> None:
    expected = 87
    actual = _parse_feels_like(weather_soup)

    assert actual == expected


def test_parse_humidity(weather_soup: Tag) -> None:
    expected = 0.57
    actual = _parse_humidity(weather_soup)

    assert actual == expected


def test_parse_wind(weather_soup: Tag) -> None:
    expected = (3, "NE")
    actual = _parse_wind(weather_soup)

    assert actual == expected


def test_parse_chance_of_precipitation(weather_soup: Tag) -> None:
    expected = 0.0
    actual = _parse_chance_of_precipitation(weather_soup)

    assert actual == expected


def test_parse_condition(weather_soup: Tag) -> None:
    expected = "Fair"
    actual = _parse_condition(weather_soup)

    assert actual == expected
