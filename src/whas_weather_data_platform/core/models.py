import datetime as dt
from typing import Annotated

from pydantic import BaseModel, PlainSerializer

WeatherDate = Annotated[
    dt.date,
    PlainSerializer(lambda value: value.isoformat(), return_type=str, when_used="json"),
]
WeatherDatetime = Annotated[
    dt.datetime,
    PlainSerializer(
        lambda value: value.isoformat(timespec="seconds"),
        return_type=str,
        when_used="json",
    ),
]


class ScrapedWeather(BaseModel):
    """Scraped weather.

    Attributes:
        scraped_at: Scraped at datetime.
    """

    scraped_at: WeatherDatetime


class DailyWeatherForecast(ScrapedWeather):
    """Daily weather forecast.

    Attributes:
        forecast_date: Forecast date.
        high_temperature_f: High temperature in fahrenheit.
        low_temperature_f: Low temperature in Fahrenheit.
        chance_of_precipitation: Chance of percipitation.
        wind_speed_mph: Wind speed in miles per hour (MPH).
        wind_direction: Wind direction.
    """

    forecast_date: WeatherDate
    high_temperature_f: int
    low_temperature_f: int
    chance_of_precipitation: float
    wind_speed_mph: int
    wind_direction: str


class HourlyWeatherForecast(ScrapedWeather):
    """Hourly weather forecast.

    Attributes:
        forecasted_for: Forecasted for datetime.
        temperature_f: Temperature in Fahrenheit.
        chance_of_precipitation: Chance of percipitation.
        wind_speed_mph: Wind speed in miles per hour (MPH).
        wind_direction: Wind direction.
    """

    forecasted_for: WeatherDatetime
    temperature_f: int
    chance_of_precipitation: float
    wind_speed_mph: int
    wind_direction: str


class HourlyWeatherObservation(ScrapedWeather):
    """Hourly weather observation.

    Attributes:
        observed_at: Observed at datetime.
        temperature_f: Temperature in Fahrenheit.
        feels_like_f: Feels like temperature in Fahrenheit.
        humidity: Humidity.
        chance_of_precipitation: Chance of percipitation.
        wind_speed_mph: Wind speed in miles per hour (MPH).
        wind_direction: Wind direction.
        condition_: Condition.
    """

    observed_at: WeatherDatetime
    temperature_f: int
    feels_like_f: int
    humidity: float
    chance_of_precipitation: float
    wind_speed_mph: int
    wind_direction: str
    condition_: str
