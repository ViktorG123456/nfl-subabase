-- Run this in your Supabase SQL Editor

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

grant all on raw.fixtures_raw to anon, authenticated, service_role;
