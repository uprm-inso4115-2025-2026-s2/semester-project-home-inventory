
-- Migration: 004_init_notifications_and_sweeps.sql
-- Description: Initialize notifications and sweep_runs tables (planned features)
-- Version: M3
-- Status: PLANNED - No Dart models yet; schema prepared for future implementation
-- Author: Home Inventory Team

-- =========================================
-- NOTIFICATION TYPES AND ENUMS
-- =========================================

create type if not exists public.notification_type as enum (
  'LOW_STOCK',
  'EXPIRING_SOON',
  'EXPIRED',
  'DUPLICATE_WARNING',
  'SHARED_INVENTORY_UPDATE',
  'OUT_OF_STOCK'
);

create type if not exists public.notification_status as enum (
  'UNREAD',
  'READ',
  'ARCHIVED',
  'DISMISSED'
);

create type if not exists public.notification_priority as enum (
  'LOW',
  'MEDIUM',
  'HIGH',
  'CRITICAL'
);

-- =========================================
-- NOTIFICATIONS TABLE (PLANNED)
-- =========================================

create table if not exists public.notifications (
  id int primary key generated always as identity,
  recipient_user_id int not null,
  inventory_item_id int,
  stock_entry_id int,
  type public.notification_type not null,
  title text not null,
  message text not null,
  priority_level public.notification_priority not null default 'MEDIUM',
  status public.notification_status not null default 'UNREAD',
  created_at timestamptz not null default now(),
  triggered_at timestamptz not null default now(),
  expires_at timestamptz,
  is_active boolean not null default true
);

comment on table public.notifications is 'PLANNED: In-app alerts for users triggered by inventory events. Awaiting Dart model implementation.';
comment on column public.notifications.id is 'Unique notification identifier';
comment on column public.notifications.recipient_user_id is 'Target user';
comment on column public.notifications.inventory_item_id is 'Related inventory item (optional)';
comment on column public.notifications.stock_entry_id is 'Related stock entry (optional)';
comment on column public.notifications.type is 'Notification type: LOW_STOCK, EXPIRING_SOON, EXPIRED, etc.';
comment on column public.notifications.title is 'Notification title';
comment on column public.notifications.message is 'Notification body';
comment on column public.notifications.priority_level is 'Priority: LOW, MEDIUM, HIGH, CRITICAL';
comment on column public.notifications.status is 'Status: UNREAD, READ, ARCHIVED, DISMISSED';
comment on column public.notifications.created_at is 'Creation timestamp';
comment on column public.notifications.triggered_at is 'When condition was detected';
comment on column public.notifications.expires_at is 'Optional expiration';
comment on column public.notifications.is_active is 'Soft delete flag';

-- =========================================
-- SWEEP RUNS TABLE (PLANNED)
-- =========================================

create type if not exists public.sweep_status as enum (
  'started',
  'success',
  'failed',
  'partial'
);

create table if not exists public.sweep_runs (
  id int primary key generated always as identity,
  started_at timestamptz not null default now(),
  completed_at timestamptz,
  status public.sweep_status not null default 'started',
  items_scanned int default 0,
  expired_flagged_count int default 0,
  near_expiration_count int default 0,
  low_stock_flagged_count int default 0,
  out_of_stock_count int default 0,
  error_summary text,
  trigger_source text,
  run_scope jsonb
);

comment on table public.sweep_runs is 'PLANNED: Audit log for automated daily sweep executions. Awaiting Dart model implementation.';
comment on column public.sweep_runs.id is 'Unique sweep run identifier';
comment on column public.sweep_runs.started_at is 'Run start time';
comment on column public.sweep_runs.completed_at is 'Run completion time (nullable)';
comment on column public.sweep_runs.status is 'Status: started, success, failed, partial';
comment on column public.sweep_runs.items_scanned is 'Number of items checked';
comment on column public.sweep_runs.expired_flagged_count is 'Expired items found';
comment on column public.sweep_runs.near_expiration_count is 'Near-expiry items found';
comment on column public.sweep_runs.low_stock_flagged_count is 'Low-stock items found';
comment on column public.sweep_runs.out_of_stock_count is 'Out-of-stock items found';
comment on column public.sweep_runs.error_summary is 'Error details if failed (nullable)';
comment on column public.sweep_runs.trigger_source is 'cron, manual, retry';
comment on column public.sweep_runs.run_scope is 'Optional scope metadata';

-- =========================================
-- INDEXES
-- =========================================

create index if not exists idx_notifications_recipient_created on public.notifications(recipient_user_id, created_at desc);
create index if not exists idx_notifications_recipient_status on public.notifications(recipient_user_id, status);
create index if not exists idx_notifications_type on public.notifications(type);
create index if not exists idx_sweep_runs_started_at on public.sweep_runs(started_at desc);
create index if not exists idx_sweep_runs_status on public.sweep_runs(status);
