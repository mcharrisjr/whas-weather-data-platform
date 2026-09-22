import datetime as dt
from zoneinfo import ZoneInfo

from bs4 import BeautifulSoup, Tag

from whas_weather_data_platform.core.models import HourlyWeatherForecast
from whas_weather_data_platform.core.parse import ensure_find


def parse_hourly_weather_forecasts(html: str) -> list[HourlyWeatherForecast]:
    """Parse hourly weather forecasts from HTML.

    Args:
        html: HTML of weather page.

    Returns:
        List of hourly weather forecasts.
    """
    soup = BeautifulSoup(html, "html.parser")

    scraped_at = dt.datetime.now(tz=ZoneInfo("America/New_York"))
    current_date = scraped_at.date()

    hourly_weather_forecasts: list[HourlyWeatherForecast] = []

    for weather_row in soup.find_all("div", class_="weather-hourly__row"):
        hourly_weather_forecasts.append(
            HourlyWeatherForecast(
                forecasted_for=_parse_forecasted_for(
                    weather_row, current_date=current_date
                ),
                temperature_f=_parse_temperature(weather_row),
                chance_of_precipitation=_parse_chance_of_precipitation(weather_row),
                wind_speed_mph=_parse_wind_speed(weather_row),
                wind_direction=_parse_wind_direction(weather_row),
                scraped_at=scraped_at,
            )
        )

    return hourly_weather_forecasts


def _parse_forecasted_for(weather_row: Tag, *, current_date: dt.date) -> dt.datetime:
    forecasted_for_str = ensure_find(
        weather_row,
        "span",
        class_="weather-hourly__hour weather-hourly__hour_visible_true",
    ).text

    eastern_tz = ZoneInfo("America/New_York")

    forecasted_for = (
        dt.datetime.strptime(forecasted_for_str, "%I %p")
        .replace(tzinfo=eastern_tz)
        .time()
    )

    return dt.datetime.combine(current_date, forecasted_for).replace(tzinfo=eastern_tz)


def _parse_temperature(weather_row: Tag) -> int:
    temperature_f_str = ensure_find(
        weather_row, "div", class_="weather-hourly__temperature-high"
    ).text
    degree_chr = chr(176)

    return int(temperature_f_str.strip(degree_chr))


def _parse_chance_of_precipitation(weather_row: Tag) -> float:
    return (
        float(
            ensure_find(
                weather_row, "div", class_="weather-hourly__precipitation-number"
            ).text.strip("%")
        )
        / 100
    )


def _parse_wind_speed(weather_row: Tag) -> int:
    return int(
        ensure_find(weather_row, "span", class_="weather-hourly__wind-number").text
    )


def _parse_wind_direction(weather_row: Tag) -> str:
    return ensure_find(
        weather_row, "span", class_="weather-hourly__wind-direction"
    ).text
