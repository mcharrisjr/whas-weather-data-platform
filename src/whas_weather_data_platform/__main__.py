import asyncio
import sys

from whas_weather_data_platform.main import main

if __name__ == "__main__":
    sys.exit(asyncio.run(main()))
