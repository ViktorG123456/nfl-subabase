from supabase import create_client, Client
from src.config import SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY

def get_supabase_client() -> Client:
    if not SUPABASE_URL or not SUPABASE_SERVICE_ROLE_KEY:
        raise ValueError("Supabase URL and Key must be set in environment variables.")
    return create_client(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)
