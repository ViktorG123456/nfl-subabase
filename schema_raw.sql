
-- Create schema for raw data if it doesn't exist
create schema if not exists raw;

-- Create table for raw players data
create table if not exists raw.players_raw (
    player_id bigint primary key,
    full_name text,
    team_id integer,
    position text,
    updated_at timestamp with time zone default timezone('utc'::text, now())
);

-- Create table for raw teams data
create table if not exists raw.teams_raw (
    team_id integer primary key,
    team_name text,
    short_name text,
    updated_at timestamp with time zone default timezone('utc'::text, now())
);

-- Create table for raw player stats (season history)
create table if not exists raw.stats_season_raw (
    element integer,
    fixture integer,
    opponent_team integer,
    total_points integer,
    was_home boolean,
    kickoff_time timestamp with time zone,
    team_h_score integer,
    team_a_score integer,
    round integer,
    minutes integer,
    goals_scored integer,
    assists integer,
    clean_sheets integer,
    goals_conceded integer,
    own_goals integer,
    penalties_saved integer,
    penalties_missed integer,
    yellow_cards integer,
    red_cards integer,
    saves integer,
    bonus integer,
    bps integer,
    clearances_blocks_interceptions integer,
    recoveries integer,
    tackles integer,
    defensive_contribution integer,
    modified boolean,
    influence text,
    creativity text,
    threat text,
    ict_index text,
    starts integer,
    expected_goals text,
    expected_assists text,
    expected_goal_involvements text,
    expected_goals_conceded text,
    value integer,
    transfers_balance integer,
    selected integer,
    transfers_in integer,
    transfers_out integer,
    updated_at timestamp with time zone default timezone('utc'::text, now()),
    primary key (element, fixture)
);

-- Create table for raw fixtures data
create table if not exists raw.fixtures_raw (
    match_id integer,
    team_id integer,
    opponent_team_id integer,
    opponent_name text,
    team_score integer,
    opponent_score integer,
    kickoff_date date,
    kickoff_time timestamp with time zone,
    gameweek integer,
    team_difficulty integer,
    is_home boolean,
    updated_at timestamp with time zone default timezone('utc'::text, now()),
    primary key (match_id, team_id)
);

-- Grant usage on schema to anon and authenticated roles (and service_role)
grant usage on schema raw to anon, authenticated, service_role;

-- Grant all privileges on all tables in schema raw to anon and authenticated roles (and service_role)
grant all on all tables in schema raw to anon, authenticated, service_role;
