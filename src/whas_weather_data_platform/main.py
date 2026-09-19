import argparse

import aiohttp
import boto3

from whas_weather_data_platform.core.enums import WeatherDataFrequency, WeatherDataType
from whas_weather_data_platform.core.s3_client import S3Client
from whas_weather_data_platform.core.whas_client import WHASClient
from whas_weather_data_platform.registry import SCRAPER_REGISTRY


def parse_args() -> argparse.Namespace:
    """Parse command line arguments.

    Returns:
        Parsed command line arguments.
    """

    parser = argparse.ArgumentParser(description="Scrape WHAS11 weather data.")

    parser.add_argument(
        "-t",
        "--type",
        type=WeatherDataType,
        choices=list(WeatherDataType),
        default=WeatherDataType.OBSERVATION,
    )
    parser.add_argument(
        "-f",
        "--frequency",
        type=WeatherDataFrequency,
        choices=list(WeatherDataFrequency),
        default=WeatherDataFrequency.HOURLY,
    )
    parser.add_argument("-u", "--url", type=str, default="https://www.whas11.com/")

    return parser.parse_args()


async def main() -> int:
    args = parse_args()

    async with aiohttp.ClientSession(base_url=args.url) as async_session:
        whas_client = WHASClient(async_session=async_session)
        html = await whas_client.weather_page()

    boto3_session = boto3.Session()
    s3_client = S3Client(s3_client=boto3_session.client("s3"))

    SCRAPER_REGISTRY[(args.type, args.frequency)](html, s3_client=s3_client)

    return 0
