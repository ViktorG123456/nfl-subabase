-- Create table for players (elements)
create table if not exists players (
    id bigint primary key,
    first_name text,
    second_name text,
    web_name text,
    team integer,
    element_type integer,
    now_cost integer,
    total_points integer,
    ep_this text,
    ep_next text,
    selected_by_percent text,
    form text,
    transfers_in integer,
    transfers_out integer,
    transfers_in_event integer,
    transfers_out_event integer,
    points_per_game text,
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
    influence text,
    creativity text,
    threat text,
    ict_index text,
    updated_at timestamp with time zone default timezone('utc'::text, now())
);

-- Create table for teams
create table if not exists teams (
    id bigint primary key,
    code integer,
    name text,
    short_name text,
    strength integer,
    updated_at timestamp with time zone default timezone('utc'::text, now())
);

-- Create table for fixtures
create table if not exists fixtures (
    id bigint primary key,
    event integer,
    team_h integer,
    team_a integer,
    team_h_score integer,
    team_a_score integer,
    kickoff_time timestamp with time zone,
    finished boolean,
    updated_at timestamp with time zone default timezone('utc'::text, now())
);
