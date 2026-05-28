# Database Migrations

This directory contains SQL migration files for the Home Inventory Supabase database.

---

# Overview

Migrations are versioned and should be applied in order:

1. **001_init_households_and_members.sql** — Core household and membership management
2. **002_init_products_and_inventory.sql** — Product catalog and inventory with JSONB stock storage
3. **003_init_expenses.sql** — Shared spending/expense tracking
4. **004_init_notifications_and_sweeps.sql** — Planned features (notifications and sweep audits)

---

# Application

## Using Supabase Console

1. Go to **Supabase Dashboard** → Your Project
2. Navigate to **SQL Editor**
3. Create a new query
4. Copy-paste the contents of each migration file in order
5. Execute each migration

---

## Using Supabase CLI (Future)

```bash
supabase db push
```

---

# Migration Status

## Implemented (M3)

- ✅ Households & Members — Core relational entities
- ✅ Products & Inventory — Catalog and JSONB-based stock storage
- ✅ Expenses — Spending transaction tracking

## Planned

- 🔄 Notifications — In-app alerts (schema prepared, awaiting Dart model)
- 🔄 Sweep Runs — Audit logging for background jobs (schema prepared, awaiting Dart model)

---

# Entity Relationships

```text
households (1) ──→ (N) household_members
households (1) ──→ (N) expenses
households (1) ──→ (N) inventories

inventories ──N:M──→ products (via JSONB stock map)

notifications → households (optional)
notifications → users

sweep_runs → (audit only, no FK)
```

---

# Key Design Decisions

## Integer Primary Keys

All tables use `SERIAL` / `GENERATED ALWAYS AS IDENTITY` for primary keys instead of UUIDs.

This aligns with the Dart model implementations which use `int` IDs.

---

## JSONB Stock Storage

The `inventories.stock` field stores a map-like structure:

```json
{
  "1": [
    {
      "id": 10,
      "brand": "Brand A",
      "quantity": 5,
      "status": "NORMAL",
      "expirationDate": "2025-12-31"
    },
    {
      "id": 11,
      "brand": "Brand B",
      "quantity": 2,
      "status": "LOW",
      "expirationDate": null
    }
  ],
  "2": []
}
```

### Structure

- **Key** = Product ID (stored as string)
- **Value** = List of Stock instances

### Benefits

This design allows:

- Flexible handling of multiple brands/batches per product
- Efficient nested filtering in Supabase
- Atomic updates via PostgreSQL JSONB operators

---

# Enum Types

PostgreSQL enums enforce type safety and consistency.

## `member_role`

- `OWNER`
- `MEMBER`
- `VIEWER`

## `product_tag`

- `BEVERAGES`
- `SNACKS`
- `DAIRY`
- `PROTEINS`
- `VEGETABLES`
- `FRUITS`
- `GRAINS`
- `CONDIMENTS`
- `FROZEN`
- `PANTRY`
- `OTHER`

## `stock_status`

- `EMPTY`
- `LOW`
- `NORMAL`
- `FULL`
- `EXPIRED`

## `notification_type`

- `LOW_STOCK`
- `EXPIRING_SOON`
- `EXPIRED`
- `DUPLICATE_WARNING`
- `SHARED_INVENTORY_UPDATE`
- `OUT_OF_STOCK`

## `notification_status`

- `UNREAD`
- `READ`
- `ARCHIVED`
- `DISMISSED`

## `notification_priority`

- `LOW`
- `MEDIUM`
- `HIGH`
- `CRITICAL`

## `sweep_status`

- `started`
- `success`
- `failed`
- `partial`

---

# Indexing Strategy

Indexes are created for common query patterns.

## Household Lookups

- `households.owner_id`

## Membership Queries

- `household_members.household_id`
- `household_members.user_id`
- `household_members.role`

## Product Searches

- `products.name`
- `products.tags` (GIN index)

## Inventory Access

- `inventories.owner_id`

## Expense Filtering

- `expenses.household_id`
- `expenses.user_id`
- `expenses.incurred_on`
- `expenses.category`

## Notification Feeds

- `notifications.recipient_user_id`
- `notifications.status`
- `notifications.created_at`

## Sweep Audits

- `sweep_runs.started_at`
- `sweep_runs.status`

---

# Future Enhancements

## Row-Level Security (RLS)

When implemented, policies should enforce:

- Users can only view inventories/expenses for households they belong to
- Users can only modify items in households where they have appropriate roles
- Notifications are only visible to the recipient

### Reference

- `docs/2-descriptive/implementation/software-design/RLSresearch.adoc`

---

## Materialized Views

Consider creating views for common aggregations:

- Household spending summary (total, by category, by member)
- Inventory health (expired count, low-stock count, out-of-stock count)
- Member contribution tracking

### Reference

- `docs/project-management/milestone-plans/milestone-2/team-4.adoc`

---

# Troubleshooting

## Foreign Key Errors

If you see foreign key constraint violations, ensure migrations are applied in order:

```text
001 → 002 → 003 → 004
```

---

## Enum Type Already Exists

If running migrations multiple times, PostgreSQL may complain about enum type duplication.

Use `IF NOT EXISTS` clauses (already included in these migrations).

---

## JSONB Query Examples

```sql
-- Get all stock for product ID '1'
SELECT stock->'1'
FROM inventories
WHERE owner_id = 5;

-- Check if product ID '1' has stock
SELECT EXISTS(
  SELECT 1
  FROM inventories
  WHERE stock ? '1'
);

-- Count total stock entries across all products
SELECT COUNT(*)
FROM (
  SELECT jsonb_array_elements(stock)
  FROM inventories
  WHERE owner_id = 5
) AS expanded;
```

---

