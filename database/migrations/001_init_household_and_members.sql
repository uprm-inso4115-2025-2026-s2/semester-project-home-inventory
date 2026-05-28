
-- Migration: 001_init_households_and_members.sql
-- Description: Initialize households and household_members tables
-- Version: M3
-- Author: Home Inventory Team

-- =========================================
-- HOUSEHOLDS TABLE
-- =========================================

create table if not exists public.households (
  id int primary key generated always as identity,
  name text not null,
  owner_id int not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table public.households is 'Represents a shared living unit where members manage household essentials';
comment on column public.households.id is 'Unique household identifier (auto-increment)';
comment on column public.households.name is 'Household name/label';
comment on column public.households.owner_id is 'User who owns the household';
comment on column public.households.created_at is 'Creation timestamp';
comment on column public.households.updated_at is 'Last update timestamp';

-- =========================================
-- HOUSEHOLD MEMBERS TABLE
-- =========================================

create type public.member_role as enum ('owner', 'member', 'viewer');

create table if not exists public.household_members (
  id int primary key generated always as identity,
  household_id int not null references public.households(id) on delete cascade,
  user_id int not null,
  role public.member_role not null default 'viewer',
  created_at timestamptz not null default now()
);

comment on table public.household_members is 'Links a user to a household with a specific role';
comment on column public.household_members.id is 'Unique member record identifier';
comment on column public.household_members.household_id is 'Reference to household';
comment on column public.household_members.user_id is 'Reference to authenticated user';
comment on column public.household_members.role is 'Role in household: owner, member, or viewer';
comment on column public.household_members.created_at is 'When membership was established';

-- =========================================
-- INDEXES
-- =========================================

create index if not exists idx_households_owner_id on public.households(owner_id);
create index if not exists idx_household_members_household_id on public.household_members(household_id);
create index if not exists idx_household_members_user_id on public.household_members(user_id);
create index if not exists idx_household_members_role on public.household_members(role);
