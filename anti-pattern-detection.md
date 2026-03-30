# Anti-Pattern Detection Queries

Run these against your PostgreSQL database to find schema problems. Each query returns rows only if a problem exists — empty result means no issue found.

## Schema Health

### Find Unindexed Foreign Keys

The #1 PostgreSQL performance problem. Every FK column needs an index.

```sql
SELECT
  conrelid::regclass AS table_name,
  a.attname AS fk_column,
  confrelid::regclass AS references_table
FROM pg_constraint c
JOIN pg_attribute a ON a.attrelid = c.conrelid AND a.attnum = ANY(c.conkey)
WHERE c.contype = 'f'
  AND NOT EXISTS (
    SELECT 1 FROM pg_index i
    WHERE i.indrelid = c.conrelid AND a.attnum = ANY(i.indkey)
  )
ORDER BY conrelid::regclass::text;
```

### Find Tables Without Primary Keys

```sql
SELECT t.tablename
FROM pg_tables t
LEFT JOIN pg_constraint c ON c.conrelid = (t.schemaname || '.' || t.tablename)::regclass AND c.contype = 'p'
WHERE t.schemaname = 'public'
  AND c.conname IS NULL
ORDER BY t.tablename;
```

### Find Columns Using Wrong Data Types

```sql
-- Find serial columns (should be identity)
SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public'
  AND column_default LIKE 'nextval%'
ORDER BY table_name;

-- Find varchar columns (should be text)
SELECT table_name, column_name, character_maximum_length
FROM information_schema.columns
WHERE table_schema = 'public'
  AND data_type = 'character varying'
ORDER BY table_name;

-- Find timestamp without timezone
SELECT table_name, column_name
FROM information_schema.columns
WHERE table_schema = 'public'
  AND data_type = 'timestamp without time zone'
ORDER BY table_name;

-- Find integer IDs (should be bigint)
SELECT table_name, column_name
FROM information_schema.columns
WHERE table_schema = 'public'
  AND column_name LIKE '%_id'
  AND data_type = 'integer'
ORDER BY table_name;
```

### Find Tables Missing created_at / updated_at

```sql
SELECT t.tablename
FROM pg_tables t
WHERE t.schemaname = 'public'
  AND NOT EXISTS (
    SELECT 1 FROM information_schema.columns c
    WHERE c.table_schema = 'public'
      AND c.table_name = t.tablename
      AND c.column_name = 'created_at'
  )
ORDER BY t.tablename;
```

### Find Nullable Columns That Should Be NOT NULL

```sql
-- Columns named 'name', 'email', 'title', 'status', 'type' that are nullable
SELECT table_name, column_name, is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
  AND is_nullable = 'YES'
  AND column_name IN ('name', 'email', 'title', 'status', 'type', 'slug')
ORDER BY table_name;
```

## Performance Health

### Find Slow Queries (requires pg_stat_statements)

```sql
SELECT
  query,
  calls,
  mean_exec_time::numeric(10,2) AS avg_ms,
  total_exec_time::numeric(10,2) AS total_ms,
  rows
FROM pg_stat_statements
WHERE mean_exec_time > 100  -- queries averaging >100ms
ORDER BY mean_exec_time DESC
LIMIT 20;
```

### Find Unused Indexes (wasting write performance)

```sql
SELECT
  schemaname,
  relname AS table_name,
  indexrelname AS index_name,
  idx_scan AS times_used,
  pg_size_pretty(pg_relation_size(indexrelid)) AS index_size
FROM pg_stat_user_indexes
WHERE idx_scan = 0
  AND schemaname = 'public'
ORDER BY pg_relation_size(indexrelid) DESC;
```

### Find Duplicate/Redundant Indexes

```sql
SELECT
  a.indexrelid::regclass AS index_a,
  b.indexrelid::regclass AS index_b,
  a.indrelid::regclass AS table_name
FROM pg_index a
JOIN pg_index b ON a.indrelid = b.indrelid
  AND a.indexrelid != b.indexrelid
  AND (a.indkey::text LIKE b.indkey::text || ' %' OR a.indkey::text = b.indkey::text)
WHERE a.indrelid::regclass::text NOT LIKE 'pg_%';
```

### Find Tables With High Bloat

```sql
SELECT
  relname AS table_name,
  n_dead_tup AS dead_rows,
  n_live_tup AS live_rows,
  ROUND(100.0 * n_dead_tup / NULLIF(n_live_tup + n_dead_tup, 0), 2) AS dead_pct,
  last_vacuum,
  last_autovacuum
FROM pg_stat_user_tables
WHERE n_dead_tup > 10000
ORDER BY n_dead_tup DESC;
```

### Find Large Tables (for partitioning candidates)

```sql
SELECT
  relname AS table_name,
  pg_size_pretty(pg_total_relation_size(relid)) AS total_size,
  pg_size_pretty(pg_relation_size(relid)) AS data_size,
  pg_size_pretty(pg_indexes_size(relid)) AS index_size,
  n_live_tup AS row_count
FROM pg_stat_user_tables
ORDER BY pg_total_relation_size(relid) DESC
LIMIT 20;
```

## Security Health

### Find Tables Without RLS (for multi-tenant apps)

```sql
SELECT
  tablename,
  rowsecurity
FROM pg_tables
WHERE schemaname = 'public'
  AND rowsecurity = false
ORDER BY tablename;
```

### Find Overly Permissive Grants

```sql
SELECT
  grantee,
  table_name,
  string_agg(privilege_type, ', ') AS privileges
FROM information_schema.table_privileges
WHERE table_schema = 'public'
  AND grantee NOT IN ('postgres', 'pg_database_owner')
GROUP BY grantee, table_name
HAVING string_agg(privilege_type, ', ') LIKE '%ALL%'
   OR string_agg(privilege_type, ', ') LIKE '%DELETE%'
ORDER BY grantee, table_name;
```

## Running These Checks

### From Drizzle / Application Code

```typescript
import { sql } from 'drizzle-orm';

// Run anti-pattern check
const unindexedFKs = await db.execute(sql`
  SELECT conrelid::regclass AS table_name, a.attname AS fk_column
  FROM pg_constraint c
  JOIN pg_attribute a ON a.attrelid = c.conrelid AND a.attnum = ANY(c.conkey)
  WHERE c.contype = 'f'
    AND NOT EXISTS (
      SELECT 1 FROM pg_index i
      WHERE i.indrelid = c.conrelid AND a.attnum = ANY(i.indkey)
    )
`);

if (unindexedFKs.rows.length > 0) {
  console.warn('⚠️ Unindexed foreign keys found:', unindexedFKs.rows);
}
```

### From Command Line

```bash
# Save these queries to a file
psql $DATABASE_URL -f anti-pattern-check.sql

# Or run inline
psql $DATABASE_URL -c "SELECT conrelid::regclass, a.attname FROM pg_constraint c JOIN pg_attribute a ON a.attrelid = c.conrelid AND a.attnum = ANY(c.conkey) WHERE c.contype = 'f' AND NOT EXISTS (SELECT 1 FROM pg_index i WHERE i.indrelid = c.conrelid AND a.attnum = ANY(i.indkey));"
```
