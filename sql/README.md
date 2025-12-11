# DBO Schema Setup

This directory contains SQL scripts to set up the `dbo` (data warehouse) schema with dimension and fact tables, plus transformation functions.

## Setup Instructions

Run these scripts **in order** in your Supabase SQL Editor:

### 1. Create DBO Schema and Tables
```bash
File: create_dbo_schema.sql
```
This creates:
- `dbo.dim_players` - Player dimension table
- `dbo.dim_teams` - Team dimension table  
- `dbo.dim_fixtures` - Fixture dimension table
- `dbo.fact_stats` - Player statistics fact table

### 2. Create Upsert Functions
```bash
File: create_upsert_functions.sql
```
This creates transformation functions:
- `dbo.upsert_dim_players()` - Transforms `raw.players_raw` → `dbo.dim_players`
- `dbo.upsert_dim_teams()` - Transforms `raw.teams_raw` → `dbo.dim_teams`
- `dbo.upsert_dim_fixtures()` - Transforms `raw.fixtures_raw` → `dbo.dim_fixtures`
- `dbo.upsert_fact_stats()` - Transforms `raw.stats_season_raw` → `dbo.fact_stats`

## How to Run in Supabase

1. Open your Supabase project dashboard
2. Navigate to **SQL Editor**
3. Create a new query
4. Copy and paste the contents of `create_dbo_schema.sql`
5. Click **Run**
6. Create another new query
7. Copy and paste the contents of `create_upsert_functions.sql`
8. Click **Run**

## Data Pipeline Flow

```
FPL API → Python Scripts → raw.* tables → Upsert Functions → dbo.* tables → Frontend
```

1. **Extract**: Python scripts fetch data from FPL API
2. **Load to Raw**: Data is loaded into `raw.*` tables
3. **Transform**: Upsert functions transform and load into `dbo.*` tables
4. **Consume**: Frontend queries `dbo.*` tables for analytics

## Usage from Python

After running the SQL scripts, you can call the functions from Python:

```python
from src.supabase_client import get_supabase_client

supabase = get_supabase_client()

# Transform players
supabase.schema('dbo').rpc('upsert_dim_players', {}).execute()

# Transform teams
supabase.schema('dbo').rpc('upsert_dim_teams', {}).execute()

# Transform fixtures
supabase.schema('dbo').rpc('upsert_dim_fixtures', {}).execute()

# Transform stats
supabase.schema('dbo').rpc('upsert_fact_stats', {}).execute()
```

## Permissions

All functions use `SECURITY DEFINER` which means they run with the permissions of the function owner (typically the database owner), allowing the service role to execute them even if it doesn't have direct table access.

The `service_role` key is granted:
- `USAGE` on the `dbo` schema
- `ALL` privileges on all tables in `dbo` schema
- `EXECUTE` on all upsert functions
