from whas_weather_data_platform.core.enums import WeatherDataFrequency, WeatherDataType
from whas_weather_data_platform.daily_forecast.scrape import (
    scrape as scrape_daily_forecast,
)
from whas_weather_data_platform.hourly_forecast.scrape import (
    scrape as scrape_hourly_forecast,
)
from whas_weather_data_platform.hourly_observation.scrape import (
    scrape as scrape_hourly_observation,
)

SCRAPER_REGISTRY = {
    (WeatherDataType.FORECAST, WeatherDataFrequency.DAILY): scrape_daily_forecast,
    (WeatherDataType.FORECAST, WeatherDataFrequency.HOURLY): scrape_hourly_forecast,
    (
        WeatherDataType.OBSERVATION,
        WeatherDataFrequency.HOURLY,
    ): scrape_hourly_observation,
}
