import asyncio
import aiohttp
import pandas as pd
import os
from dotenv import load_dotenv
from supabase import create_client, Client
from tqdm.asyncio import tqdm

# Load environment variables
load_dotenv()

url = os.environ.get("SUPABASE_URL")
key = os.environ.get("SUPABASE_KEY")

if not url or not key:
    raise ValueError("SUPABASE_URL and SUPABASE_KEY must be set in .env file")

supabase: Client = create_client(url, key)

async def fetch_player_stats(session, player_id, semaphore):
    url = f"https://fantasy.premierleague.com/api/element-summary/{player_id}/"
    async with semaphore:
        try:
            async with session.get(url) as response:
                response.raise_for_status()
                data = await response.json()
                current_season = data.get("history", [])
                return current_season
        except Exception as e:
            print(f"Error fetching stats for player {player_id}: {e}")
            return []

async def main():
    print("Fetching players list from Supabase...")
    try:
        # Fetch all players
        response = supabase.postgrest.schema('raw').table('players_raw').select('player_id').execute()
        players = response.data
    except Exception as e:
        print(f"Error fetching players: {e}")
        return

    if not players:
        print("No players found in raw.players_raw. Please run players_raw.py first.")
        return

    print(f"Found {len(players)} players. Fetching stats...")

    # Semaphore to limit concurrent requests (e.g., 50 concurrent requests)
    semaphore = asyncio.Semaphore(50)
    
    all_stats = []
    
    async with aiohttp.ClientSession() as session:
        tasks = []
        for player in players:
            player_id = player['player_id']
            task = fetch_player_stats(session, player_id, semaphore)
            tasks.append(task)
        
        # Use tqdm for progress bar
        results = await tqdm.gather(*tasks, desc="Fetching stats")
        
        for res in results:
            if res:
                all_stats.extend(res)

    if not all_stats:
        print("No stats data collected.")
        return

    # Combine everything into one DataFrame
    season_df = pd.DataFrame(all_stats)
    print("Dataframe created:")
    print(season_df.head())
    print(f"Total rows: {len(season_df)}")

    # Write to Supabase
    print("Writing to Supabase table 'raw.stats_season_raw'...")
    
    data = season_df.to_dict(orient='records')
    
    # Chunking
    chunk_size = 1000
    total_chunks = (len(data) + chunk_size - 1) // chunk_size
    
    for i in range(0, len(data), chunk_size):
        chunk = data[i:i + chunk_size]
        print(f"Writing chunk {i//chunk_size + 1}/{total_chunks}...")
        try:
            supabase.postgrest.schema('raw').table('stats_season_raw').upsert(chunk).execute()
        except Exception as e:
            print(f"Error writing chunk {i//chunk_size + 1}: {e}")

    print("Successfully wrote stats data to Supabase.")

if __name__ == "__main__":
    asyncio.run(main())
