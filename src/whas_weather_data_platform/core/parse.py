from bs4 import Tag

from whas_weather_data_platform.core.exceptions import MissingHTMLElement


def ensure_find(tag: Tag, *args, **kwargs) -> Tag:
    """Ensure HTML element find.

    Args:
        tag: HTML tag.

    Returns:
        HTML element.
    """
    element = tag.find(*args, **kwargs)

    if element is None:
        msg = "Missing HTML element: Sought HTML element is missing."
        raise MissingHTMLElement(msg)

    return element
