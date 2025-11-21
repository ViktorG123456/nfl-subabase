import requests
import pandas as pd
import os
from dotenv import load_dotenv
from supabase import create_client, Client

# Load environment variables
load_dotenv()

url = os.environ.get("SUPABASE_URL")
key = os.environ.get("SUPABASE_KEY")

if not url or not key:
    raise ValueError("SUPABASE_URL and SUPABASE_KEY must be set in .env file")

supabase: Client = create_client(url, key)

def main():
    # Step 1 – Get bootstrap-static data
    bootstrap_url = "https://fantasy.premierleague.com/api/bootstrap-static/"
    print(f"Fetching data from {bootstrap_url}...")
    response = requests.get(bootstrap_url)
    response.raise_for_status()
    bootstrap_data = response.json()

    players_data = bootstrap_data["elements"]
    positions_data = bootstrap_data["element_types"]

    # Step 2: Create mappings
    position_map = {pos["id"]: pos["singular_name"] for pos in positions_data}

    # Step 2 – Build a list with only required fields
    player_list = []
    for p in players_data:
        player_info = {
            "player_id": p["id"],
            "full_name": f"{p['first_name']} {p['second_name']}",
            "team_id": p["team"],
            "position": position_map[p["element_type"]]
        }
        player_list.append(player_info)

    # Step 3 – Create DataFrame
    player_df = pd.DataFrame(player_list)
    print("Dataframe created:")
    print(player_df.head())

    # Write to Supabase
    print("Writing to Supabase table 'raw.players_raw'...")
    
    # Convert DataFrame to list of dicts for Supabase insertion
    data = player_df.to_dict(orient='records')
    
    # Upsert data to Supabase
    # Note: Supabase-py client uses 'table' method. 
    # If the table is in a schema other than public, we might need to specify it.
    # However, the supabase-py client usually defaults to public. 
    # If we created 'raw.players_raw', we need to see how to access it.
    # Usually it's supabase.table('players_raw').upsert(data).execute() if it's in public.
    # If it's in 'raw' schema, we might need to configure the client or use a different approach.
    # But for now, let's assume the user will run the SQL to create it in 'raw' schema.
    # The supabase client allows changing schema.
    
    # Using a separate client with schema 'raw' or specifying schema in table call if supported.
    # The standard client defaults to 'public'. 
    # We can switch schema: supabase.postgrest.schema('raw')
    
    try:
        supabase.postgrest.schema('raw').table('players_raw').upsert(data).execute()
        print("Successfully wrote data to Supabase.")
    except Exception as e:
        print(f"Error writing to Supabase: {e}")

if __name__ == "__main__":
    main()
