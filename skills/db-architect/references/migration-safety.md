# Migration Safety — Zero-Downtime Patterns

How to change your database without breaking your running application. Compiled from wshobson/agents sql-migrations, affaan-m/everything-claude-code database-migrations, Supabase constraint safety patterns.

## Core Principles

1. **Every change is a migration file** — never ALTER production manually
2. **Migrations are immutable once deployed** — never edit a deployed migration
3. **Schema changes and data changes are SEPARATE migrations** — never mix DDL and DML
4. **Test against production-sized data** — what works on 100 rows may lock on 10M

## The Expand-Contract Pattern

The safest way to make any structural change. Three phases, each is a separate deployment:

```
Phase 1: EXPAND (backward compatible)
  - Add new column/table (nullable or with default)
  - Deploy: app writes to BOTH old and new
  - Run data backfill

Phase 2: TRANSITION
  - Deploy: app reads from NEW, writes to BOTH
  - Verify data consistency

Phase 3: CONTRACT
  - Deploy: app only uses NEW
  - Drop old column/table in separate migration

Timeline:
  Day 1: Add new column (nullable)
  Day 1: Deploy app v2 (dual-write)
  Day 2: Backfill existing rows
  Day 3: Deploy app v3 (read from new)
  Day 7: Drop old column
```

## Safe Operations (Instant, No Locks)

These operations are safe to run anytime:

```sql
-- Add nullable column (instant in PG11+)
ALTER TABLE users ADD COLUMN avatar_url TEXT;

-- Add column with non-volatile default (instant in PG11+)
ALTER TABLE users ADD COLUMN is_active BOOLEAN NOT NULL DEFAULT true;

-- Create index concurrently (no write locks)
CREATE INDEX CONCURRENTLY idx_users_email ON users (email);

-- Add foreign key without validation (instant)
ALTER TABLE orders ADD CONSTRAINT fk_orders_user
  FOREIGN KEY (user_id) REFERENCES users(id) NOT VALID;

-- Validate constraint separately (scans but doesn't lock writes)
ALTER TABLE orders VALIDATE CONSTRAINT fk_orders_user;
```

## Dangerous Operations (Require Planning)

### Adding NOT NULL Without Default — TABLE REWRITE

```sql
-- DANGEROUS: Rewrites entire table, locks it
ALTER TABLE users ADD COLUMN role TEXT NOT NULL;

-- SAFE: Three-step approach
-- Step 1: Add nullable
ALTER TABLE users ADD COLUMN role TEXT;
-- Step 2: Backfill in batches
UPDATE users SET role = 'member' WHERE role IS NULL;  -- in batches!
-- Step 3: Add NOT NULL via check constraint (no rewrite)
ALTER TABLE users ADD CONSTRAINT chk_role_not_null CHECK (role IS NOT NULL) NOT VALID;
ALTER TABLE users VALIDATE CONSTRAINT chk_role_not_null;
```

### Renaming a Column — USE EXPAND-CONTRACT

```sql
-- NEVER: Direct rename breaks running application
ALTER TABLE users RENAME COLUMN username TO display_name;

-- SAFE: Expand-contract
-- Migration 1: Add new column
ALTER TABLE users ADD COLUMN display_name TEXT;
-- Migration 2: Backfill (separate migration)
UPDATE users SET display_name = username WHERE display_name IS NULL;
-- Deploy: app writes to both, reads from display_name
-- Migration 3: Drop old column (after full deploy)
ALTER TABLE users DROP COLUMN username;
```

### Dropping a Column — REMOVE CODE FIRST

```sql
-- WRONG ORDER: Drop column then fix code (app crashes)
ALTER TABLE orders DROP COLUMN legacy_status;

-- RIGHT ORDER:
-- Step 1: Remove all code references to legacy_status
-- Step 2: Deploy application (no code uses the column)
-- Step 3: Drop column in next migration
ALTER TABLE orders DROP COLUMN IF EXISTS legacy_status;
```

### Creating Index on Large Table — USE CONCURRENTLY

```sql
-- BLOCKS WRITES on large tables:
CREATE INDEX idx_orders_status ON orders (status);

-- DOES NOT BLOCK WRITES:
CREATE INDEX CONCURRENTLY idx_orders_status ON orders (status);

-- NOTE: CONCURRENTLY cannot run inside a transaction
-- Drizzle migrations run in transactions by default
-- For concurrent indexes, use custom migration SQL
```

## Drizzle ORM Migration Workflow

```bash
# Generate migration from schema changes
npx drizzle-kit generate

# Review the generated SQL before applying
cat drizzle/XXXX_migration_name/migration.sql

# Apply in development (pushes directly, no migration file)
npx drizzle-kit push

# Apply in production (runs migration files)
npx drizzle-kit migrate

# Check migration status
npx drizzle-kit check
```

### Custom Migration for CONCURRENTLY

Drizzle Kit generates standard CREATE INDEX inside transactions. For large tables:

1. Generate the migration normally
2. Edit the SQL file: change `CREATE INDEX` to `CREATE INDEX CONCURRENTLY`
3. Remove the transaction wrapper (CONCURRENTLY can't run in transactions)

## Large Data Backfill Pattern

```sql
-- NEVER: One giant UPDATE (locks table for minutes/hours)
UPDATE users SET normalized_email = LOWER(email);

-- ALWAYS: Batch update with progress
DO $$
DECLARE
  batch_size INT := 10000;
  rows_updated INT;
BEGIN
  LOOP
    UPDATE users
    SET normalized_email = LOWER(email)
    WHERE id IN (
      SELECT id FROM users
      WHERE normalized_email IS NULL
      LIMIT batch_size
      FOR UPDATE SKIP LOCKED
    );
    GET DIAGNOSTICS rows_updated = ROW_COUNT;
    EXIT WHEN rows_updated = 0;
    COMMIT;
    PERFORM pg_sleep(0.1);  -- Brief pause to reduce load
  END LOOP;
END $$;
```

## Constraint Safety in Migrations

PostgreSQL does NOT support `ADD CONSTRAINT IF NOT EXISTS`. Use this pattern:

```sql
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'my_constraint_name'
  ) THEN
    ALTER TABLE my_table ADD CONSTRAINT my_constraint_name UNIQUE (column);
  END IF;
END $$;
```

## Migration Checklist

Before deploying any migration:

- [ ] New columns are nullable or have non-volatile defaults
- [ ] Indexes created with CONCURRENTLY for existing large tables
- [ ] Data backfill is a SEPARATE migration from schema change
- [ ] No direct column renames (use expand-contract)
- [ ] Code changes deployed BEFORE dropping columns
- [ ] Tested against production-sized data copy
- [ ] Rollback plan documented (what to run if this fails)
- [ ] Migration is idempotent (safe to run twice)

## Anti-Pattern Summary

| Anti-Pattern | Risk | Safe Alternative |
|-------------|------|-----------------|
| NOT NULL without default on existing table | Full table rewrite + lock | Nullable → backfill → CHECK constraint |
| CREATE INDEX (without CONCURRENTLY) | Blocks writes | CREATE INDEX CONCURRENTLY |
| DROP COLUMN before removing code | Application errors | Remove code → deploy → drop column |
| Schema + data in one migration | Long transaction, hard rollback | Separate migrations |
| Editing deployed migrations | Drift between environments | New forward migration |
| Manual SQL in production | No audit trail | Always use migration files |
| Renaming column directly | Breaks running app | Expand-contract pattern |
