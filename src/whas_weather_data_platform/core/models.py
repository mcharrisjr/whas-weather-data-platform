import datetime as dt

from pydantic import BaseModel, field_serializer


class ScrapedWeather(BaseModel):
    """Scraped weather.

    Attributes:
        scraped_at: Scraped at datetime.
    """

    scraped_at: dt.datetime

    @field_serializer("scraped_at", when_used="json")
    def serialize_scraped_at(self, value: dt.datetime) -> str:
        return value.isoformat(timespec="seconds")



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

    forecast_date: dt.date
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

    forecasted_for: dt.datetime
    temperature_f: int
    chance_of_precipitation: float
    wind_speed_mph: int
    wind_direction: str

    @field_serializer("forecasted_for", when_used="json")
    def serialize_forecasted_for(self, value: dt.datetime) -> str:
        return value.isoformat(timespec="seconds")


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

    observed_at: dt.datetime
    temperature_f: int
    feels_like_f: int
    humidity: float
    chance_of_precipitation: float
    wind_speed_mph: int
    wind_direction: str
    condition_: str

    @field_serializer("observed_at", when_used="json")
    def serialize_observed_at(self, value: dt.datetime) -> str:
        return value.isoformat(timespec="seconds")
