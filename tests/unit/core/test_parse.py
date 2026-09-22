import pytest
from bs4 import Tag

from whas_weather_data_platform.core.exceptions import MissingHTMLElement
from whas_weather_data_platform.core.parse import ensure_find


def test_ensure_find_when_missing_element_raises_error(weather_soup: Tag) -> None:
    with pytest.raises(MissingHTMLElement, match="Missing HTML element"):
        ensure_find(weather_soup, "div", class_="missing-class")


def test_ensure_find(weather_soup: Tag) -> None:
    element = ensure_find(weather_soup, "div", class_="right-now-radar__condition")

    assert element.text == "Fair"
