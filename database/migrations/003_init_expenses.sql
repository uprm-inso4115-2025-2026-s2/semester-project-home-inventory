
-- Migration: 003_init_expenses.sql
-- Description: Initialize expenses (spending) table for shared budget tracking
-- Version: M3
-- Author: Home Inventory Team

-- =========================================
-- EXPENSES TABLE
-- =========================================

create table if not exists public.expenses (
  id int primary key generated always as identity,
  household_id int not null references public.households(id) on delete cascade,
  user_id int,
  amount decimal(10, 2) not null,
  category text,
  description text,
  incurred_on timestamptz not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table public.expenses is 'Records financial transactions for households (shared spending tracking)';
comment on column public.expenses.id is 'Unique expense identifier';
comment on column public.expenses.household_id is 'Associated household';
comment on column public.expenses.user_id is 'User who logged the spending (optional)';
comment on column public.expenses.amount is 'Monetary value';
comment on column public.expenses.category is 'Spending category (optional)';
comment on column public.expenses.description is 'Optional notes/description';
comment on column public.expenses.incurred_on is 'When transaction occurred';
comment on column public.expenses.created_at is 'Record creation timestamp';
comment on column public.expenses.updated_at is 'Last update timestamp';

-- =========================================
-- INDEXES
-- =========================================

create index if not exists idx_expenses_household_id on public.expenses(household_id);
create index if not exists idx_expenses_user_id on public.expenses(user_id);
create index if not exists idx_expenses_incurred_on on public.expenses(incurred_on desc);
create index if not exists idx_expenses_category on public.expenses(category);
