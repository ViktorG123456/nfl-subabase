# SQL Functions for FPL Pipeline

## Truncate Raw Tables Functions

The `truncate_raw_tables.sql` file contains PostgreSQL functions to truncate raw schema tables.

### Setup Instructions

1. **Run the SQL script in Supabase**:
   - Open your Supabase project dashboard
   - Go to the SQL Editor
   - Copy and paste the contents of `truncate_raw_tables.sql`
   - Execute the script

2. **Grant permissions** (if needed):
   - Uncomment the GRANT statements at the end of the SQL file
   - Adjust the role (`authenticated`, `anon`, etc.) based on your security requirements

### Available Functions

#### Individual Table Truncation
- `raw.truncate_players_raw()` - Truncates only the players_raw table
- `raw.truncate_teams_raw()` - Truncates only the teams_raw table
- `raw.truncate_stats_season_raw()` - Truncates only the stats_season_raw table
- `raw.truncate_fixtures_raw()` - Truncates only the fixtures_raw table

#### Master Truncation Function
- `raw.truncate_all_raw_tables()` - Truncates all raw tables at once

### Usage from Python

The pipeline automatically calls `truncate_all_raw_tables()` at the start:

```python
# This is already implemented in pipeline.py
supabase.rpc('truncate_all_raw_tables').execute()
```

### Manual Usage in SQL

You can also call these functions directly in the Supabase SQL Editor:

```sql
-- Truncate all raw tables
SELECT raw.truncate_all_raw_tables();

-- Or truncate individual tables
SELECT raw.truncate_players_raw();
SELECT raw.truncate_teams_raw();
SELECT raw.truncate_stats_season_raw();
SELECT raw.truncate_fixtures_raw();
```

### Benefits

- **Performance**: `TRUNCATE` is faster than `DELETE` for clearing entire tables
- **Cleaner**: Database-level operations are more efficient than application-level deletes
- **Reusable**: Functions can be called from Python, SQL, or other tools
- **Atomic**: Each function executes as a single transaction
