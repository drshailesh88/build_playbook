# PostgreSQL Golden Rules

Compiled from: Timescale pg-aiguide, Supabase agent-skills, wshobson/agents database-design plugin.

## Data Types — What to Use and What to Avoid

### ALWAYS Use

| Data | Type | Why |
|------|------|-----|
| IDs (default) | `BIGINT GENERATED ALWAYS AS IDENTITY` | Sequential, 8 bytes, SQL-standard, no fragmentation |
| IDs (distributed) | `UUID` via `gen_random_uuid()` or `uuid_generate_v7()` | UUIDv7 preferred (time-ordered, no index fragmentation) |
| Strings | `TEXT` | Same performance as varchar, no arbitrary limits |
| Timestamps | `TIMESTAMPTZ` | Always stores timezone info, prevents timezone bugs |
| Money | `NUMERIC(p,s)` | Exact decimal arithmetic, no floating-point errors |
| Booleans | `BOOLEAN NOT NULL` | 1 byte, proper true/false semantics |
| JSON data | `JSONB` | Binary format, indexable with GIN, supports containment queries |
| Embeddings | `halfvec(N)` via pgvector | 50% storage of full vector, minimal recall loss |

### NEVER Use

| Bad Type | Why | Use Instead |
|----------|-----|-------------|
| `serial` | Non-standard, implicit sequence | `BIGINT GENERATED ALWAYS AS IDENTITY` |
| `int` / `integer` for IDs | Overflows at 2.1 billion | `BIGINT` (9 quintillion max) |
| `varchar(n)` | Arbitrary limit, same performance as text | `TEXT` + `CHECK (LENGTH(col) <= n)` if limit needed |
| `char(n)` | Pads with spaces, wastes storage | `TEXT` |
| `timestamp` (no tz) | Loses timezone info, causes bugs | `TIMESTAMPTZ` |
| `float` / `real` for money | Precision errors (0.1 + 0.2 ≠ 0.3) | `NUMERIC(p,s)` |
| `money` type | Locale-dependent, limited precision | `NUMERIC(p,s)` |
| `json` | Text storage, no indexing | `JSONB` |
| `timetz` | Meaningless without date | `TIMESTAMPTZ` |
| random `UUID v4` as PK | Index fragmentation on large tables | UUIDv7 or BIGINT identity |

### Enum Strategy

- **Stable, small sets** (days of week, US states): `CREATE TYPE ... AS ENUM`
- **Evolving business values** (order statuses, user roles): `TEXT + CHECK constraint`
  - Reason: You can add values to a CHECK constraint. You CANNOT remove values from an ENUM type without recreating it.

```sql
-- Good: evolving status
status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'suspended', 'deleted'))

-- Good: stable set
CREATE TYPE day_of_week AS ENUM ('monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday');
```

## Indexing Rules

### Mandatory Indexes

1. **Every foreign key column** — PostgreSQL does NOT auto-index FKs. Missing FK indexes cause slow JOINs and table-locking CASCADE deletes.
2. **Every column used in WHERE clauses** on large tables
3. **Every column used in ORDER BY** on large tables

### Index Types

| Type | Use For | Example |
|------|---------|---------|
| B-tree (default) | Equality, range, ORDER BY | `CREATE INDEX ON orders (user_id)` |
| Composite | Multi-column filters | `CREATE INDEX ON orders (status, created_at)` — equality columns first, then range |
| Covering | Index-only scans | `CREATE INDEX ON users (email) INCLUDE (name, created_at)` |
| Partial | Hot subsets | `CREATE INDEX ON users (email) WHERE deleted_at IS NULL` |
| Expression | Computed lookups | `CREATE INDEX ON users (LOWER(email))` |
| GIN | JSONB, arrays, full-text | `CREATE INDEX ON docs USING GIN (metadata)` |
| GiST | Ranges, geometry, exclusion | `CREATE INDEX ON bookings USING GiST (date_range)` |
| BRIN | Very large, time-ordered tables | `CREATE INDEX ON logs USING BRIN (created_at)` |

### Find Missing FK Indexes

```sql
SELECT conrelid::regclass AS table_name, a.attname AS fk_column
FROM pg_constraint c
JOIN pg_attribute a ON a.attrelid = c.conrelid AND a.attnum = ANY(c.conkey)
WHERE c.contype = 'f'
  AND NOT EXISTS (
    SELECT 1 FROM pg_index i
    WHERE i.indrelid = c.conrelid AND a.attnum = ANY(i.indkey)
  );
```

## Constraints

- `PRIMARY KEY`: implicit UNIQUE + NOT NULL, creates B-tree index
- `FOREIGN KEY`: always specify `ON DELETE` action + add explicit index
- `UNIQUE`: creates B-tree index. Use `NULLS NOT DISTINCT` (PG15+) to prevent multiple NULLs
- `CHECK`: row-level validation. NULL values pass checks — combine with NOT NULL
- `NOT NULL`: add everywhere semantically required. Prevents surprise nulls

## JSONB Patterns

- Use JSONB for semi-structured, optional, or variable attributes
- Keep core relationships in proper tables — JSONB for extras
- Default GIN index: `CREATE INDEX ON tbl USING GIN (jsonb_col)`
- For specific field queries: create generated column + B-tree index
- Constrain structure: `CHECK(jsonb_typeof(config) = 'object')`

## Connection and Performance

- Connection pool size: `(2 × CPU cores) + number_of_disks`
- For cloud SSDs: start with `2 × vCPUs`
- Use cursor pagination (`WHERE id > $last ORDER BY id LIMIT 20`) not OFFSET
- OFFSET is O(n), cursor is O(1)
- Batch inserts: multi-row INSERT or COPY, never individual inserts in loops
- Keep transactions short — never hold locks during external API calls

## PostgreSQL Gotchas

1. Unquoted identifiers are lowercased — always use snake_case
2. UNIQUE allows multiple NULLs (use NULLS NOT DISTINCT on PG15+)
3. FK columns are NOT auto-indexed — you must add indexes manually
4. Length overflows ERROR (no silent truncation like MySQL)
5. Sequence gaps are normal — don't try to make IDs consecutive
6. Updates create dead tuples — vacuum handles them, design to minimize hot-row churn
7. `CLUSTER` is a one-time operation, not maintained on inserts
8. Adding NOT NULL column without default REWRITES the entire table (locks it)
9. `CREATE INDEX` (without CONCURRENTLY) blocks writes
10. Volatile defaults (like `now()`, `gen_random_uuid()`) on NOT NULL columns cause full table rewrite
