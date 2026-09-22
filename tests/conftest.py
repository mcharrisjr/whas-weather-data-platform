from pathlib import Path

import pytest
from bs4 import BeautifulSoup, Tag


@pytest.fixture(scope="session")
def weather_soup() -> Tag:
    with open(
        Path(__file__).parent / "assets" / "whas_weather_202609211130.html",
        "r",
        encoding="utf-8",
    ) as f:
        html = f.read()

    return BeautifulSoup(html, "html.parser")
