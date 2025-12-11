import requests
import pandas as pd
import os
from dotenv import load_dotenv
from supabase import create_client, Client

# Load environment variables
load_dotenv()

url = os.environ.get("SUPABASE_URL")
service_key = os.environ.get("SUPABASE_KEY")  # Use service role key

supabase: Client = create_client(url, service_key)

data = supabase.schema('dbo').rpc('upsert_dim_players', {}).execute()
print(data)
