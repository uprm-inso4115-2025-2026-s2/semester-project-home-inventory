
-- Migration: 002_init_products_and_inventory.sql
-- Description: Initialize products and inventory tables with stock JSONB storage
-- Version: M3
-- Author: Home Inventory Team

-- =========================================
-- PRODUCTS TABLE
-- =========================================

create type public.product_tag as enum (
  'BEVERAGES',
  'SNACKS',
  'DAIRY',
  'PROTEINS',
  'VEGETABLES',
  'FRUITS',
  'GRAINS',
  'CONDIMENTS',
  'FROZEN',
  'PANTRY',
  'OTHER'
);

create table if not exists public.products (
  id int primary key generated always as identity,
  name text not null,
  description text not null,
  tags public.product_tag[] default '{}',
  unit text,
  image_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table public.products is 'Defines product types independent of inventory instances (shared catalog items)';
comment on column public.products.id is 'Unique product identifier';
comment on column public.products.name is 'Product name (e.g., Milk)';
comment on column public.products.description is 'Product description';
comment on column public.products.tags is 'Array of product tags for categorization';
comment on column public.products.unit is 'Unit of measure (ct, lb, oz, L, etc.)';
comment on column public.products.image_url is 'Optional URL to product image';

-- =========================================
-- INVENTORIES TABLE
-- =========================================

create type public.stock_status as enum ('EMPTY', 'LOW', 'NORMAL', 'FULL', 'EXPIRED');

create table if not exists public.inventories (
  id int primary key generated always as identity,
  owner_id int not null,
  stock jsonb not null default '{}',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table public.inventories is 'Represents a container (room, household) that holds stock of products'
  || E'\n'
  || 'Stock field is a Map: { "product_id": [{stock_entry}, ...], ... }';
comment on column public.inventories.id is 'Unique inventory identifier';
comment on column public.inventories.owner_id is 'Owner ID (room, household, or user identifier)';
comment on column public.inventories.stock is 'JSONB map of product_id → List<Stock> (stores stock instances)';
comment on column public.inventories.created_at is 'Creation timestamp';
comment on column public.inventories.updated_at is 'Last update timestamp';

-- =========================================
-- INDEXES
-- =========================================

create index if not exists idx_products_name on public.products(name);
create index if not exists idx_products_tags on public.products using gin(tags);
create index if not exists idx_inventories_owner_id on public.inventories(owner_id);
