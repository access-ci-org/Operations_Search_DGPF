import logging
from django.conf import settings
from provider.models import Provider

log = logging.getLogger(__name__)


def lookup_replace_provider_id(facets: dict) -> dict:
    """Replace all values within the Provider_ID with nice names from
    the lookup table above"""
    for facet in facets:
        if facet["field_name"] == "Provider_ID":
            for bucket in facet["buckets"]:
                try:
                    bucket["custom_display_value"] = Provider.objects.get(Provider_ID=bucket["value"]).Provider_Name
                except Provider.DoesNotExist:
                    log.warning(f"Provider {bucket['value']} is unknown and needs to be "
                                "added to the database!")
                    bucket["custom_display_value"] = "Other"
    return facets


def combine_info_group(facets: list) -> list:
    """Collapse Info_GroupID and Info_GroupName into a single 'Resource Group'
    facet that filters by name. Drops the raw ID facet from display."""
    combined = []
    for facet in facets:
        if facet["field_name"] == "Info_GroupID":
            continue
        if facet["field_name"] == "Info_GroupName":
            facet = dict(facet)
            facet["name"] = "Resource Group"
        combined.append(facet)
    return combined
