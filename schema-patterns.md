# SaaS Schema Patterns

Common database patterns for SaaS applications. Use these as templates when designing tables for subscription-based, multi-user, multi-tenant applications.

## Multi-Tenancy

### Recommended: Shared Database, Shared Schema with tenant_id

Add `organization_id` (or `tenant_id`) to every tenant-scoped table. This is the simplest, most scalable approach.

```typescript
// Every tenant-scoped table gets this column
organizationId: bigint('organization_id', { mode: 'number' }).notNull()
  .references(() => organizations.id),

// MANDATORY: Index the tenant column (it's in every WHERE clause)
index('idx_projects_org_id').on(table.organizationId),

// Composite indexes should lead with tenant_id
index('idx_projects_org_status').on(table.organizationId, table.status),
```

**Why this over separate databases/schemas:**
- One codebase, one migration pipeline
- Connection pooling works normally
- No per-tenant operational overhead
- Scales to thousands of tenants
- PostgreSQL RLS provides database-level isolation

### Row-Level Security (RLS) for Tenant Isolation

```sql
-- Enable RLS
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects FORCE ROW LEVEL SECURITY;

-- Policy: users only see their organization's data
CREATE POLICY projects_tenant_policy ON projects
  FOR ALL
  USING (organization_id = current_setting('app.current_org_id')::bigint);

-- Set context before queries (in application middleware)
SET app.current_org_id = '42';
```

### Organization and Membership Tables

```typescript
export const organizations = pgTable('organizations', {
  id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
  name: text('name').notNull(),
  slug: text('slug').notNull().unique(),
  plan: text('plan').notNull().default('free'),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
});

export const organizationMembers = pgTable('organization_members', {
  id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
  organizationId: bigint('organization_id', { mode: 'number' }).notNull()
    .references(() => organizations.id, { onDelete: 'cascade' }),
  userId: bigint('user_id', { mode: 'number' }).notNull()
    .references(() => users.id, { onDelete: 'cascade' }),
  role: text('role').notNull().default('member'),
  invitedBy: bigint('invited_by', { mode: 'number' }).references(() => users.id),
  joinedAt: timestamp('joined_at', { withTimezone: true }).notNull().defaultNow(),
}, (table) => [
  unique('uq_org_member').on(table.organizationId, table.userId),
  index('idx_org_members_org').on(table.organizationId),
  index('idx_org_members_user').on(table.userId),
]);
```

## Subscription and Billing

```typescript
export const plans = pgTable('plans', {
  id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
  name: text('name').notNull().unique(),
  displayName: text('display_name').notNull(),
  priceMonthly: numeric('price_monthly', { precision: 10, scale: 2 }).notNull(),
  priceYearly: numeric('price_yearly', { precision: 10, scale: 2 }).notNull(),
  limits: jsonb('limits').notNull().default('{}'),
  // limits example: { "projects": 10, "documents": 100, "ai_queries": 1000, "storage_mb": 5000 }
  isActive: boolean('is_active').notNull().default(true),
  sortOrder: integer('sort_order').notNull().default(0),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
});

export const subscriptions = pgTable('subscriptions', {
  id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
  organizationId: bigint('organization_id', { mode: 'number' }).notNull()
    .references(() => organizations.id, { onDelete: 'cascade' }),
  planId: bigint('plan_id', { mode: 'number' }).notNull()
    .references(() => plans.id),
  status: text('status').notNull().default('active'),
  // 'active', 'past_due', 'canceled', 'trialing', 'paused'
  currentPeriodStart: timestamp('current_period_start', { withTimezone: true }).notNull(),
  currentPeriodEnd: timestamp('current_period_end', { withTimezone: true }).notNull(),
  canceledAt: timestamp('canceled_at', { withTimezone: true }),
  paymentProvider: text('payment_provider'), // 'razorpay', 'stripe'
  externalId: text('external_id'), // ID in payment provider
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
}, (table) => [
  index('idx_subscriptions_org').on(table.organizationId),
  index('idx_subscriptions_status').on(table.status),
]);

export const usageRecords = pgTable('usage_records', {
  id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
  organizationId: bigint('organization_id', { mode: 'number' }).notNull()
    .references(() => organizations.id),
  resourceType: text('resource_type').notNull(),
  // 'project', 'document', 'ai_query', 'storage_bytes', 'api_call'
  quantity: bigint('quantity', { mode: 'number' }).notNull().default(1),
  periodStart: timestamp('period_start', { withTimezone: true }).notNull(),
  periodEnd: timestamp('period_end', { withTimezone: true }).notNull(),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
}, (table) => [
  index('idx_usage_org_type_period').on(table.organizationId, table.resourceType, table.periodStart),
]);
```

## Audit Trail

```typescript
export const auditLog = pgTable('audit_log', {
  id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
  organizationId: bigint('organization_id', { mode: 'number' }).references(() => organizations.id),
  userId: bigint('user_id', { mode: 'number' }).references(() => users.id),
  action: text('action').notNull(),
  // 'create', 'update', 'delete', 'login', 'export', 'share'
  resourceType: text('resource_type').notNull(),
  // 'project', 'document', 'user', 'subscription'
  resourceId: text('resource_id').notNull(),
  changes: jsonb('changes'),
  // { "title": { "old": "Draft", "new": "Final Report" } }
  ipAddress: text('ip_address'),
  userAgent: text('user_agent'),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
}, (table) => [
  index('idx_audit_org').on(table.organizationId),
  index('idx_audit_user').on(table.userId),
  index('idx_audit_resource').on(table.resourceType, table.resourceId),
  index('idx_audit_created').on(table.createdAt),
]);
// NOTE: Audit tables should NEVER have soft deletes. Audit records are immutable.
// Consider partitioning by created_at for large audit tables (>100M rows).
```

## Soft Delete Pattern

```typescript
// Add to any table that needs recoverable deletion:
deletedAt: timestamp('deleted_at', { withTimezone: true }),

// Application-level: all queries add WHERE deleted_at IS NULL
// Database-level: partial index excludes deleted records
index('idx_projects_active').on(table.userId).where(sql`deleted_at IS NULL`),

// Cleanup job: permanently delete records older than retention period
// DELETE FROM projects WHERE deleted_at < now() - INTERVAL '30 days';
```

## Notification Pattern

```typescript
export const notifications = pgTable('notifications', {
  id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
  userId: bigint('user_id', { mode: 'number' }).notNull()
    .references(() => users.id, { onDelete: 'cascade' }),
  type: text('type').notNull(),
  title: text('title').notNull(),
  body: text('body'),
  data: jsonb('data').default('{}'),
  // Stores context: { "projectId": 123, "documentId": 456, "action": "comment" }
  readAt: timestamp('read_at', { withTimezone: true }),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
}, (table) => [
  index('idx_notifications_user_unread').on(table.userId).where(sql`read_at IS NULL`),
  index('idx_notifications_user_created').on(table.userId, table.createdAt),
]);
```

## API Keys / External Access

```typescript
export const apiKeys = pgTable('api_keys', {
  id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
  organizationId: bigint('organization_id', { mode: 'number' }).notNull()
    .references(() => organizations.id, { onDelete: 'cascade' }),
  name: text('name').notNull(),
  keyHash: text('key_hash').notNull(), // Store hash, never the raw key
  keyPrefix: text('key_prefix').notNull(), // First 8 chars for identification
  scopes: jsonb('scopes').notNull().default('["read"]'),
  lastUsedAt: timestamp('last_used_at', { withTimezone: true }),
  expiresAt: timestamp('expires_at', { withTimezone: true }),
  createdBy: bigint('created_by', { mode: 'number' }).references(() => users.id),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  revokedAt: timestamp('revoked_at', { withTimezone: true }),
}, (table) => [
  index('idx_api_keys_org').on(table.organizationId),
  index('idx_api_keys_hash').on(table.keyHash),
]);
```

## Data Export / Compliance (GDPR-like)

```typescript
export const dataExportRequests = pgTable('data_export_requests', {
  id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
  userId: bigint('user_id', { mode: 'number' }).notNull()
    .references(() => users.id),
  type: text('type').notNull(), // 'export_all', 'delete_all'
  status: text('status').notNull().default('pending'),
  // 'pending', 'processing', 'completed', 'failed'
  completedAt: timestamp('completed_at', { withTimezone: true }),
  downloadUrl: text('download_url'), // Signed URL to download export
  expiresAt: timestamp('expires_at', { withTimezone: true }),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
}, (table) => [
  index('idx_export_user').on(table.userId),
  index('idx_export_status').on(table.status),
]);
```
