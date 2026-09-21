import datetime as dt
from zoneinfo import ZoneInfo

from bs4 import BeautifulSoup

from whas_weather_data_platform.core.models import HourlyWeatherObservation
from whas_weather_data_platform.core.parse import ensure_find


def parse_hourly_weather_observation(html: str) -> HourlyWeatherObservation:
    """Parse hourly weather observation from HTML.

    Args:
        html: HTML of weather page.

    Returns:
        Hourly weather observation.
    """
    soup = BeautifulSoup(html, "html.parser")

    scraped_at = dt.datetime.now(tz=ZoneInfo("America/New_York"))

    wind_speed_mph, wind_direction = _parse_wind(soup)

    return HourlyWeatherObservation(
        observed_at=scraped_at,
        temperature_f=_parse_temperature(soup),
        feels_like_f=_parse_feels_like(soup),
        humidity=_parse_humidity(soup),
        chance_of_precipitation=_parse_chance_of_precipitation(soup),
        wind_speed_mph=wind_speed_mph,
        wind_direction=wind_direction,
        condition_=_parse_condition(soup),
        scraped_at=scraped_at,
    )


def _parse_temperature(soup: BeautifulSoup) -> int:
    return int(ensure_find(soup, "div", class_="right-now-radar__temp").text)


def _parse_feels_like(soup: BeautifulSoup) -> int:
    degree_chr = chr(176)

    return int(
        ensure_find(soup, "div", class_="right-now-radar__feels-like")
        .text.lstrip()
        .strip(degree_chr)
    )


def _parse_humidity(soup: BeautifulSoup) -> float:
    return (
        float(
            ensure_find(soup, "div", class_="right-now-radar__humidity")
            .text.lstrip()
            .strip("%")
        )
        / 100
    )


def _parse_wind(soup: BeautifulSoup) -> tuple[int, str]:
    wind_str = ensure_find(soup, "div", class_="right-now-radar__wind").text.lstrip()
    wind_speed, _, wind_direction = wind_str.split()

    return int(wind_speed), wind_direction


def _parse_chance_of_precipitation(soup: BeautifulSoup) -> float:
    return (
        float(
            ensure_find(soup, "div", class_="right-now-radar__rain")
            .text.lstrip()
            .strip("%")
        )
        / 100
    )


def _parse_condition(soup: BeautifulSoup) -> str:
    return ensure_find(soup, "div", class_="right-now-radar__condition").text
