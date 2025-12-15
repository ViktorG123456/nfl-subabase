-- Create dbo schema if it doesn't exist
CREATE SCHEMA IF NOT EXISTS dbo;

-- Grant usage on schema to service_role
GRANT USAGE ON SCHEMA dbo TO service_role;
GRANT ALL ON ALL TABLES IN SCHEMA dbo TO service_role;

-- Create dim_players table
CREATE TABLE IF NOT EXISTS dbo.dim_players (
    player_id BIGINT PRIMARY KEY,
    full_name TEXT,
    team_id INTEGER,
    position TEXT,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW())
);

-- Create dim_teams table
CREATE TABLE IF NOT EXISTS dbo.dim_teams (
    team_id INTEGER PRIMARY KEY,
    team_name TEXT,
    short_name TEXT,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW())
);

-- Create dim_fixtures table
CREATE TABLE IF NOT EXISTS dbo.dim_fixtures (
    match_id INTEGER,
    team_id INTEGER,
    opponent_team_id INTEGER,
    opponent_name TEXT,
    team_score INTEGER,
    opponent_score INTEGER,
    kickoff_date DATE,
    kickoff_time TIMESTAMP WITH TIME ZONE,
    gameweek INTEGER,
    team_difficulty INTEGER,
    is_home BOOLEAN,
    finished BOOLEAN,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()),
    PRIMARY KEY (match_id, team_id)
);

-- Create fact_stats table
CREATE TABLE IF NOT EXISTS dbo.fact_stats (
    element INTEGER,
    fixture INTEGER,
    opponent_team INTEGER,
    total_points INTEGER,
    was_home BOOLEAN,
    kickoff_time TIMESTAMP WITH TIME ZONE,
    team_h_score INTEGER,
    team_a_score INTEGER,
    round INTEGER,
    minutes INTEGER,
    goals_scored INTEGER,
    assists INTEGER,
    clean_sheets INTEGER,
    goals_conceded INTEGER,
    own_goals INTEGER,
    penalties_saved INTEGER,
    penalties_missed INTEGER,
    yellow_cards INTEGER,
    red_cards INTEGER,
    saves INTEGER,
    bonus INTEGER,
    bps INTEGER,
    clearances_blocks_interceptions INTEGER,
    recoveries INTEGER,
    tackles INTEGER,
    defensive_contribution INTEGER,
    modified BOOLEAN,
    influence TEXT,
    creativity TEXT,
    threat TEXT,
    ict_index TEXT,
    starts INTEGER,
    expected_goals TEXT,
    expected_assists TEXT,
    expected_goal_involvements TEXT,
    expected_goals_conceded TEXT,
    value INTEGER,
    transfers_balance INTEGER,
    selected INTEGER,
    transfers_in INTEGER,
    transfers_out INTEGER,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()),
    PRIMARY KEY (element, fixture)
);

-- Grant permissions on tables
GRANT ALL ON dbo.dim_players TO service_role;
GRANT ALL ON dbo.dim_teams TO service_role;
GRANT ALL ON dbo.dim_fixtures TO service_role;
GRANT ALL ON dbo.fact_stats TO service_role;
