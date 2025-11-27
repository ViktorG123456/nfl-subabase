from src.fpl_client import get_bootstrap_static, get_fixtures
from src.supabase_client import get_supabase_client
def filter_data(data_list, allowed_keys):
    """Filters a list of dictionaries to keep only allowed keys."""
    filtered_list = []
    for item in data_list:
        filtered_item = {k: item.get(k) for k in allowed_keys if k in item}
        filtered_list.append(filtered_item)
    return filtered_list

def main():
    supabase = get_supabase_client()

    print("Fetching bootstrap data from FPL API...")
    bootstrap_data = get_bootstrap_static()
    
    # Process Teams
    print("Processing teams...")
    teams = bootstrap_data['teams']
    team_fields = ['id', 'code', 'name', 'short_name', 'strength']
    filtered_teams = filter_data(teams, team_fields)
    
    response = supabase.table('teams').upsert(filtered_teams).execute()
    print(f"Upserted {len(filtered_teams)} teams.")

    # Process Players
    print("Processing players...")
    players = bootstrap_data['elements']
    player_fields = [
        'id', 'first_name', 'second_name', 'web_name', 'team', 'element_type',
        'now_cost', 'total_points', 'ep_this', 'ep_next', 'selected_by_percent',
        'form', 'transfers_in', 'transfers_out', 'transfers_in_event',
        'transfers_out_event', 'points_per_game', 'minutes', 'goals_scored',
        'assists', 'clean_sheets', 'goals_conceded', 'own_goals', 'penalties_saved',
        'penalties_missed', 'yellow_cards', 'red_cards', 'saves', 'bonus', 'bps',
        'influence', 'creativity', 'threat', 'ict_index'
    ]
    filtered_players = filter_data(players, player_fields)
    
    # Upsert in batches to avoid payload limits if necessary, but 600 players should be fine
    response = supabase.table('players').upsert(filtered_players).execute()
    print(f"Upserted {len(filtered_players)} players.")

    # Process Fixtures
    print("Fetching fixtures from FPL API...")
    fixtures = get_fixtures()
    print(f"Fetched {len(fixtures)} fixtures.")
    
    fixture_fields = [
        'id', 'event', 'team_h', 'team_a', 'team_h_score', 'team_a_score',
        'kickoff_time', 'finished'
    ]
    filtered_fixtures = filter_data(fixtures, fixture_fields)
    
    # Fixtures can be many (380), batching is safer but single call might work
    response = supabase.table('fixtures').upsert(filtered_fixtures).execute()
    print(f"Upserted {len(filtered_fixtures)} fixtures.")

    print("Data sync complete!")

if __name__ == "__main__":
    main()
