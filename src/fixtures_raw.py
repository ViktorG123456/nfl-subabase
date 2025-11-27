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
    print("Fetching fixtures from FPL API...")
    fixtures_url = "https://fantasy.premierleague.com/api/fixtures/"
    try:
        response = requests.get(fixtures_url)
        response.raise_for_status()
        fixtures_data = response.json()
    except Exception as e:
        print(f"Error fetching fixtures: {e}")
        return

    if not fixtures_data:
        print("No fixtures data found.")
        return

    fixtures_df = pd.DataFrame(fixtures_data)
    print(f"Fetched {len(fixtures_df)} fixtures.")

    print("Fetching teams from Supabase...")
    try:
        response = supabase.postgrest.schema('raw').table('teams_raw').select('team_id, team_name').execute()
        teams_data = response.data
        teams_df = pd.DataFrame(teams_data)
    except Exception as e:
        print(f"Error fetching teams: {e}")
        return

    if teams_df.empty:
        print("No teams found in raw.teams_raw. Please run teams_raw.py first.")
        return

    # Prepare long format
    # Home rows
    home_df = fixtures_df.copy()
    home_df = home_df.rename(columns={
        "id": "match_id",
        "team_h": "team_id",
        "team_a": "opponent_team_id",
        "team_h_score": "team_score",
        "team_a_score": "opponent_score",
        "team_h_difficulty": "team_difficulty",
        "event": "gameweek"
    })
    home_df["is_home"] = True
    
    # Away rows
    away_df = fixtures_df.copy()
    away_df = away_df.rename(columns={
        "id": "match_id",
        "team_a": "team_id",
        "team_h": "opponent_team_id",
        "team_a_score": "team_score",
        "team_h_score": "opponent_score",
        "team_a_difficulty": "team_difficulty",
        "event": "gameweek"
    })
    away_df["is_home"] = False

    # Select common columns
    cols = [
        "match_id", "team_id", "opponent_team_id", "team_score", "opponent_score", 
        "kickoff_time", "team_difficulty", "gameweek", "is_home", "finished"
    ]
    
    fact_fixtures_long = pd.concat([home_df[cols], away_df[cols]], ignore_index=True)
    
    # Convert kickoff_time to datetime and extract date
    fact_fixtures_long["kickoff_time"] = pd.to_datetime(fact_fixtures_long["kickoff_time"])
    fact_fixtures_long["kickoff_date"] = fact_fixtures_long["kickoff_time"].dt.date.astype(str)
    fact_fixtures_long["kickoff_time"] = fact_fixtures_long["kickoff_time"].astype(str) # Convert back to string for JSON serialization

    # Join with teams to get opponent name
    # We need to join on opponent_team_id = team_id from teams_df
    merged_df = fact_fixtures_long.merge(
        teams_df, 
        left_on="opponent_team_id", 
        right_on="team_id", 
        how="left",
        suffixes=("", "_opp")
    )
    
    # Rename team_name to opponent_name
    merged_df = merged_df.rename(columns={"team_name": "opponent_name"})
    
    # Select final columns
    final_cols = [
        "match_id", "team_id", "opponent_team_id", "opponent_name", 
        "team_score", "opponent_score", "kickoff_date", "kickoff_time", 
        "gameweek", "team_difficulty", "is_home", "finished"
    ]
    
    result_df = merged_df[final_cols].copy()
    
    # Ensure integer columns are actually integers (nullable)
    # This fixes the issue where scores are floats like 2.0 which Postgres rejects for integer columns
    int_cols = ["team_score", "opponent_score", "gameweek", "team_difficulty"]
    for col in int_cols:
        result_df[col] = pd.to_numeric(result_df[col], errors='coerce').astype('Int64')
    
    # Handle NaN values (e.g. future fixtures might have NaN scores)
    # We need to convert to object type first to allow None values
    result_df = result_df.astype(object).where(pd.notnull(result_df), None)

    print("Dataframe created:")
    print(result_df.head())
    print(f"Total rows: {len(result_df)}")

    # Write to Supabase
    print("Writing to Supabase table 'raw.fixtures_raw'...")
    
    data = result_df.to_dict(orient='records')
    
    chunk_size = 1000
    for i in range(0, len(data), chunk_size):
        chunk = data[i:i + chunk_size]
        print(f"Writing chunk {i//chunk_size + 1}...")
        try:
            supabase.postgrest.schema('raw').table('fixtures_raw').upsert(chunk).execute()
        except Exception as e:
            print(f"Error writing chunk {i//chunk_size + 1}: {e}")

    print("Successfully wrote fixtures data to Supabase.")

if __name__ == "__main__":
    main()
