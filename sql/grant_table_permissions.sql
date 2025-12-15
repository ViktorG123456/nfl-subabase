-- Grant permissions on dbo schema tables to service_role
-- This is needed for the upsert functions to work properly

-- Grant permissions on dim_players table
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE dbo.dim_players TO service_role;

-- Grant permissions on dim_teams table
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE dbo.dim_teams TO service_role;

-- Grant permissions on dim_fixtures table
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE dbo.dim_fixtures TO service_role;

-- Grant permissions on fact_stats table
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE dbo.fact_stats TO service_role;

-- Also grant permissions on raw schema tables (for reading)
GRANT SELECT ON TABLE raw.players_raw TO service_role;
GRANT SELECT ON TABLE raw.teams_raw TO service_role;
GRANT SELECT ON TABLE raw.fixtures_raw TO service_role;
GRANT SELECT ON TABLE raw.stats_season_raw TO service_role;

-- Grant TRUNCATE permissions on raw tables for truncate functions
GRANT TRUNCATE ON TABLE raw.players_raw TO service_role;
GRANT TRUNCATE ON TABLE raw.teams_raw TO service_role;
GRANT TRUNCATE ON TABLE raw.fixtures_raw TO service_role;
GRANT TRUNCATE ON TABLE raw.stats_season_raw TO service_role;

-- Grant usage on schemas
GRANT USAGE ON SCHEMA dbo TO service_role;
GRANT USAGE ON SCHEMA raw TO service_role;
