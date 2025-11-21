-- Run this in your Supabase SQL Editor to update the table schema

ALTER TABLE raw.stats_season_raw 
ADD COLUMN IF NOT EXISTS clearances_blocks_interceptions integer,
ADD COLUMN IF NOT EXISTS recoveries integer,
ADD COLUMN IF NOT EXISTS tackles integer,
ADD COLUMN IF NOT EXISTS defensive_contribution integer,
ADD COLUMN IF NOT EXISTS modified boolean,
ADD COLUMN IF NOT EXISTS starts integer,
ADD COLUMN IF NOT EXISTS expected_goals text,
ADD COLUMN IF NOT EXISTS expected_assists text,
ADD COLUMN IF NOT EXISTS expected_goal_involvements text,
ADD COLUMN IF NOT EXISTS expected_goals_conceded text;
