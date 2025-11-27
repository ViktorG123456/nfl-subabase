-- Function to truncate individual raw tables
-- These functions can be called via Supabase RPC from Python

-- Truncate players_raw table
CREATE OR REPLACE FUNCTION raw.truncate_players_raw()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    TRUNCATE TABLE raw.players_raw;
    RAISE NOTICE 'Truncated raw.players_raw';
END;
$$;

-- Truncate teams_raw table
CREATE OR REPLACE FUNCTION raw.truncate_teams_raw()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    TRUNCATE TABLE raw.teams_raw;
    RAISE NOTICE 'Truncated raw.teams_raw';
END;
$$;

-- Truncate stats_season_raw table
CREATE OR REPLACE FUNCTION raw.truncate_stats_season_raw()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    TRUNCATE TABLE raw.stats_season_raw;
    RAISE NOTICE 'Truncated raw.stats_season_raw';
END;
$$;

-- Truncate fixtures_raw table
CREATE OR REPLACE FUNCTION raw.truncate_fixtures_raw()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    TRUNCATE TABLE raw.fixtures_raw;
    RAISE NOTICE 'Truncated raw.fixtures_raw';
END;
$$;

-- Master function to truncate all raw tables at once
CREATE OR REPLACE FUNCTION raw.truncate_all_raw_tables()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    TRUNCATE TABLE raw.players_raw;
    RAISE NOTICE 'Truncated raw.players_raw';
    
    TRUNCATE TABLE raw.teams_raw;
    RAISE NOTICE 'Truncated raw.teams_raw';
    
    TRUNCATE TABLE raw.stats_season_raw;
    RAISE NOTICE 'Truncated raw.stats_season_raw';
    
    TRUNCATE TABLE raw.fixtures_raw;
    RAISE NOTICE 'Truncated raw.fixtures_raw';
    
    RAISE NOTICE 'All raw tables truncated successfully';
END;
$$;

-- Grant execute permissions (adjust as needed for your security model)
-- GRANT EXECUTE ON FUNCTION raw.truncate_players_raw() TO authenticated;
-- GRANT EXECUTE ON FUNCTION raw.truncate_teams_raw() TO authenticated;
-- GRANT EXECUTE ON FUNCTION raw.truncate_stats_season_raw() TO authenticated;
-- GRANT EXECUTE ON FUNCTION raw.truncate_fixtures_raw() TO authenticated;
-- GRANT EXECUTE ON FUNCTION raw.truncate_all_raw_tables() TO authenticated;
