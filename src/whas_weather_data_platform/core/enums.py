from enum import StrEnum


class WeatherDataFrequency(StrEnum):
    """Weather data frequency."""

    DAILY = "daily"
    HOURLY = "hourly"


class WeatherDataType(StrEnum):
    """Weather data type."""

    FORECAST = "forecast"
    OBSERVATION = "observation"
