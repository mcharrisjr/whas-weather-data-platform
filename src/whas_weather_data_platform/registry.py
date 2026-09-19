from whas_weather_data_platform.core.enums import WeatherDataFrequency, WeatherDataType
from whas_weather_data_platform.forecast_daily.scrape import (
    scrape as scrape_forecast_daily,
)
from whas_weather_data_platform.forecast_hourly.scrape import (
    scrape as scrape_forecast_hourly,
)
from whas_weather_data_platform.observation_hourly.scrape import (
    scrape as scrape_observation_hourly,
)

SCRAPER_REGISTRY = {
    (WeatherDataType.FORECAST, WeatherDataFrequency.DAILY): scrape_forecast_daily,
    (WeatherDataType.FORECAST, WeatherDataFrequency.HOURLY): scrape_forecast_hourly,
    (
        WeatherDataType.OBSERVATION,
        WeatherDataFrequency.HOURLY,
    ): scrape_observation_hourly,
}
