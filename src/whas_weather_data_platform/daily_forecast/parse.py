import datetime as dt
from zoneinfo import ZoneInfo

from bs4 import BeautifulSoup, Tag

from whas_weather_data_platform.core.models import DailyWeatherForecast
from whas_weather_data_platform.core.parse import ensure_find


def parse_daily_weather_forecasts(html: str) -> list[DailyWeatherForecast]:
    """Parse daily weather forecasts from HTML.

    Args:
        html: HTML of weather page.

    Returns:
        List of daily weather forecasts.
    """
    soup = BeautifulSoup(html, "html.parser")

    scraped_at = dt.datetime.now(tz=ZoneInfo("America/New_York"))
    current_year = scraped_at.year

    daily_weather_forecasts: list[DailyWeatherForecast] = []

    for weather_row in soup.find_all("div", class_="weather-10-day__row"):
        daily_weather_forecasts.append(
            DailyWeatherForecast(
                forecast_date=_parse_forecast_date(
                    weather_row, current_year=current_year
                ),
                high_temperature_f=_parse_high_temperature(weather_row),
                low_temperature_f=_parse_low_temperature(weather_row),
                chance_of_precipitation=_parse_chance_of_precipitation(weather_row),
                wind_speed_mph=_parse_wind_speed(weather_row),
                wind_direction=_parse_wind_direction(weather_row),
                scraped_at=scraped_at,
            )
        )

    return daily_weather_forecasts


def _parse_forecast_date(weather_row: Tag, *, current_year: int) -> dt.date:
    forecast_date_str = ensure_find(
        weather_row,
        "span",
        class_="weather-10-day__date weather-10-day__date_visible_true",
    ).text
    forecast_date = (
        dt.datetime.strptime(f"{forecast_date_str} {current_year}", "%b %d %Y")
        .replace(tzinfo=ZoneInfo("America/New_York"))
        .date()
    )

    return forecast_date


def _parse_high_temperature(weather_row: Tag) -> int:
    return int(
        ensure_find(weather_row, "div", class_="weather-10-day__temperature-high").text
    )


def _parse_low_temperature(weather_row: Tag) -> int:
    return int(
        ensure_find(weather_row, "div", class_="weather-10-day__temperature-low").text
    )


def _parse_chance_of_precipitation(weather_row: Tag) -> float:
    return (
        float(
            ensure_find(
                weather_row, "div", class_="weather-10-day__precipitation-number"
            ).text.strip("%")
        )
        / 100
    )


def _parse_wind_speed(weather_row: Tag) -> int:
    return int(
        ensure_find(weather_row, "span", class_="weather-10-day__wind-number").text
    )


def _parse_wind_direction(weather_row: Tag) -> str:
    return ensure_find(
        weather_row, "span", class_="weather-10-day__wind-direction"
    ).text
