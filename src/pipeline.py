import asyncio
import sys
import os

# Ensure src is in path
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))

from src import players_raw
from src import teams_raw
from src import fixtures_raw
from src import stats_raw
from src.supabase_client import get_supabase_client

def run_rpc(supabase, function_name):
    print(f"Calling RPC function: {function_name}...")
    try:
        # Note: We strip the schema if present because Supabase RPC usually expects just the function name
        # unless the function name itself contains a dot.
        # The user provided names like 'dim.upsert_dim_players', so we'll try the name after the dot.
        actual_func_name = function_name.split('.')[-1]
        response = supabase.rpc(actual_func_name).execute()
        print(f"Successfully called {actual_func_name}")
    except Exception as e:
        print(f"Error calling {function_name}: {e}")

def main():
    print("Starting pipeline...")

    # 1. players_raw.py
    print("\n--- Running players_raw.py ---")
    try:
        players_raw.main()
    except Exception as e:
        print(f"Error in players_raw: {e}")

    # 2. teams_raw.py
    print("\n--- Running teams_raw.py ---")
    try:
        teams_raw.main()
    except Exception as e:
        print(f"Error in teams_raw: {e}")

    # 3. stats_raw.py
    print("\n--- Running stats_raw.py ---")
    try:
        asyncio.run(stats_raw.main())
    except Exception as e:
        print(f"Error in stats_raw: {e}")

    # 4. fixtures_raw.py
    print("\n--- Running fixtures_raw.py ---")
    try:
        fixtures_raw.main()
    except Exception as e:
        print(f"Error in fixtures_raw: {e}")

    # 5. Supabase RPC functions
    print("\n--- Running Supabase RPC functions ---")
    try:
        supabase = get_supabase_client()
        
        # User requested: dim.upsert_dim_players, dim.upsert_dim_teams, fact.upsert_stats
        rpc_functions = [
            'dim.upsert_dim_players',
            'dim.upsert_dim_teams',
            'fact.upsert_stats'
        ]
        
        for func in rpc_functions:
            run_rpc(supabase, func)
            
    except Exception as e:
        print(f"Error initializing Supabase client or running RPCs: {e}")

    print("\nPipeline complete!")

if __name__ == "__main__":
    main()
