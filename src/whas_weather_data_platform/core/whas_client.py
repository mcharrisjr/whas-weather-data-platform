import aiohttp


class WHASClient:
    """WHAS client.

    Attributes:
        _async_session (aiohttp.ClientSession): Asychronous client session.
    """

    def __init__(self, *, async_session: aiohttp.ClientSession) -> None:
        self._async_session = async_session

    async def weather_page(self) -> str:
        """Get HTML of weather page.

        Returns:
            HTML of weather page.
        """
        async with self._async_session.get(
            "weather/", raise_for_status=True
        ) as response:
            return await response.text()
