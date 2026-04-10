from django import template
from urllib.parse import unquote

register = template.Library()

@register.filter
def urldecode(value):
    if value is None:
        return value
    return unquote(value)