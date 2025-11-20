import requests
from src.config import FPL_API_URL

def get_bootstrap_static():
    """Fetches the bootstrap-static endpoint from FPL API."""
    url = f"{FPL_API_URL}bootstrap-static/"
    response = requests.get(url)
    response.raise_for_status()
    return response.json()

def get_fixtures():
    """Fetches fixtures from FPL API."""
    url = f"{FPL_API_URL}fixtures/"
    response = requests.get(url)
    response.raise_for_status()
    return response.json()
