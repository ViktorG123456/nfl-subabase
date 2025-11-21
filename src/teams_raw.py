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

    teams_data = bootstrap_data["teams"]

    # Step 2 – Extract id and name
    team_list = []
    for t in teams_data:
        team_info = {
            "team_id": t["id"],
            "team_name": t["name"],
            "short_name": t["short_name"]
        }
        team_list.append(team_info)

    # Step 3 – Create DataFrame
    teams_df = pd.DataFrame(team_list)
    print("Dataframe created:")
    print(teams_df.head())

    # Write to Supabase
    print("Writing to Supabase table 'raw.teams_raw'...")
    
    data = teams_df.to_dict(orient='records')
    
    try:
        # Using schema('raw') as established in previous steps
        supabase.postgrest.schema('raw').table('teams_raw').upsert(data).execute()
        print("Successfully wrote data to Supabase.")
    except Exception as e:
        print(f"Error writing to Supabase: {e}")

if __name__ == "__main__":
    main()
