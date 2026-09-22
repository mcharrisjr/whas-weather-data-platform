from unittest.mock import AsyncMock, patch

import aiohttp

from whas_weather_data_platform.core.whas_client import WHASClient


async def test_weather_page() -> None:
    mock_response = AsyncMock(spec=aiohttp.ClientResponse)
    mock_response.status = 200
    mock_response.text.return_value = "test"

    async with aiohttp.ClientSession() as async_session:
        whas_client = WHASClient(async_session=async_session)

        with patch.object(whas_client._async_session, "get", autospec=True) as mock_get:
            mock_get.return_value.__aenter__.return_value = mock_response

            response = await whas_client.weather_page()

            mock_get.assert_called_once_with(
                "weather/",
                raise_for_status=True,
            )

            mock_response.text.assert_awaited_once()

            assert response == "test"
