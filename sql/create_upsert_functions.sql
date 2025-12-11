-- Function to upsert data from raw.players_raw to dbo.dim_players
CREATE OR REPLACE FUNCTION dbo.upsert_dim_players()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    INSERT INTO dbo.dim_players (player_id, full_name, team_id, position, updated_at)
    SELECT 
        player_id,
        full_name,
        team_id,
        position,
        updated_at
    FROM raw.players_raw
    ON CONFLICT (player_id) 
    DO UPDATE SET
        full_name = EXCLUDED.full_name,
        team_id = EXCLUDED.team_id,
        position = EXCLUDED.position,
        updated_at = EXCLUDED.updated_at;
END;
$$;

-- Function to upsert data from raw.teams_raw to dbo.dim_teams
CREATE OR REPLACE FUNCTION dbo.upsert_dim_teams()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    INSERT INTO dbo.dim_teams (team_id, team_name, short_name, updated_at)
    SELECT 
        team_id,
        team_name,
        short_name,
        updated_at
    FROM raw.teams_raw
    ON CONFLICT (team_id) 
    DO UPDATE SET
        team_name = EXCLUDED.team_name,
        short_name = EXCLUDED.short_name,
        updated_at = EXCLUDED.updated_at;
END;
$$;

-- Function to upsert data from raw.fixtures_raw to dbo.dim_fixtures
CREATE OR REPLACE FUNCTION dbo.upsert_dim_fixtures()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    INSERT INTO dbo.dim_fixtures (
        match_id, team_id, opponent_team_id, opponent_name,
        team_score, opponent_score, kickoff_date, kickoff_time,
        gameweek, team_difficulty, is_home, updated_at
    )
    SELECT 
        match_id,
        team_id,
        opponent_team_id,
        opponent_name,
        team_score,
        opponent_score,
        kickoff_date,
        kickoff_time,
        gameweek,
        team_difficulty,
        is_home,
        updated_at
    FROM raw.fixtures_raw
    ON CONFLICT (match_id, team_id) 
    DO UPDATE SET
        opponent_team_id = EXCLUDED.opponent_team_id,
        opponent_name = EXCLUDED.opponent_name,
        team_score = EXCLUDED.team_score,
        opponent_score = EXCLUDED.opponent_score,
        kickoff_date = EXCLUDED.kickoff_date,
        kickoff_time = EXCLUDED.kickoff_time,
        gameweek = EXCLUDED.gameweek,
        team_difficulty = EXCLUDED.team_difficulty,
        is_home = EXCLUDED.is_home,
        updated_at = EXCLUDED.updated_at;
END;
$$;

-- Function to upsert data from raw.stats_season_raw to dbo.fact_stats
CREATE OR REPLACE FUNCTION dbo.upsert_fact_stats()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    INSERT INTO dbo.fact_stats (
        element, fixture, opponent_team, total_points, was_home,
        kickoff_time, team_h_score, team_a_score, round, minutes,
        goals_scored, assists, clean_sheets, goals_conceded, own_goals,
        penalties_saved, penalties_missed, yellow_cards, red_cards, saves,
        bonus, bps, clearances_blocks_interceptions, recoveries, tackles,
        defensive_contribution, modified, influence, creativity, threat,
        ict_index, starts, expected_goals, expected_assists,
        expected_goal_involvements, expected_goals_conceded, value,
        transfers_balance, selected, transfers_in, transfers_out, updated_at
    )
    SELECT 
        element, fixture, opponent_team, total_points, was_home,
        kickoff_time, team_h_score, team_a_score, round, minutes,
        goals_scored, assists, clean_sheets, goals_conceded, own_goals,
        penalties_saved, penalties_missed, yellow_cards, red_cards, saves,
        bonus, bps, clearances_blocks_interceptions, recoveries, tackles,
        defensive_contribution, modified, influence, creativity, threat,
        ict_index, starts, expected_goals, expected_assists,
        expected_goal_involvements, expected_goals_conceded, value,
        transfers_balance, selected, transfers_in, transfers_out, updated_at
    FROM raw.stats_season_raw
    ON CONFLICT (element, fixture) 
    DO UPDATE SET
        opponent_team = EXCLUDED.opponent_team,
        total_points = EXCLUDED.total_points,
        was_home = EXCLUDED.was_home,
        kickoff_time = EXCLUDED.kickoff_time,
        team_h_score = EXCLUDED.team_h_score,
        team_a_score = EXCLUDED.team_a_score,
        round = EXCLUDED.round,
        minutes = EXCLUDED.minutes,
        goals_scored = EXCLUDED.goals_scored,
        assists = EXCLUDED.assists,
        clean_sheets = EXCLUDED.clean_sheets,
        goals_conceded = EXCLUDED.goals_conceded,
        own_goals = EXCLUDED.own_goals,
        penalties_saved = EXCLUDED.penalties_saved,
        penalties_missed = EXCLUDED.penalties_missed,
        yellow_cards = EXCLUDED.yellow_cards,
        red_cards = EXCLUDED.red_cards,
        saves = EXCLUDED.saves,
        bonus = EXCLUDED.bonus,
        bps = EXCLUDED.bps,
        clearances_blocks_interceptions = EXCLUDED.clearances_blocks_interceptions,
        recoveries = EXCLUDED.recoveries,
        tackles = EXCLUDED.tackles,
        defensive_contribution = EXCLUDED.defensive_contribution,
        modified = EXCLUDED.modified,
        influence = EXCLUDED.influence,
        creativity = EXCLUDED.creativity,
        threat = EXCLUDED.threat,
        ict_index = EXCLUDED.ict_index,
        starts = EXCLUDED.starts,
        expected_goals = EXCLUDED.expected_goals,
        expected_assists = EXCLUDED.expected_assists,
        expected_goal_involvements = EXCLUDED.expected_goal_involvements,
        expected_goals_conceded = EXCLUDED.expected_goals_conceded,
        value = EXCLUDED.value,
        transfers_balance = EXCLUDED.transfers_balance,
        selected = EXCLUDED.selected,
        transfers_in = EXCLUDED.transfers_in,
        transfers_out = EXCLUDED.transfers_out,
        updated_at = EXCLUDED.updated_at;
END;
$$;

-- Grant execute permissions on functions to service_role
GRANT EXECUTE ON FUNCTION dbo.upsert_dim_players() TO service_role;
GRANT EXECUTE ON FUNCTION dbo.upsert_dim_teams() TO service_role;
GRANT EXECUTE ON FUNCTION dbo.upsert_dim_fixtures() TO service_role;
GRANT EXECUTE ON FUNCTION dbo.upsert_fact_stats() TO service_role;
