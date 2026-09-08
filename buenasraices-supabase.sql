create table if not exists public.admins (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  customer_name text not null check (char_length(customer_name) between 2 and 120),
  phone text not null check (char_length(phone) between 6 and 40),
  address text not null check (char_length(address) between 4 and 180),
  streets text not null check (char_length(streets) between 2 and 180),
  zone text not null check (char_length(zone) between 2 and 80),
  notes text,
  status text not null default 'pendiente'
    check (status in ('pendiente', 'confirmado', 'entregado', 'cancelado'))
);

create table if not exists public.order_items (
  id bigint generated always as identity primary key,
  order_id uuid not null references public.orders(id) on delete cascade,
  product_id text not null,
  product_name text not null,
  price_per_kg numeric(12,2) not null check (price_per_kg >= 0),
  grams numeric(10,1) not null check (grams > 0),
  out_of_stock boolean not null default false
);

create index if not exists orders_zone_created_at_idx
  on public.orders(zone, created_at desc);

create index if not exists order_items_order_id_idx
  on public.order_items(order_id);

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.admins
    where user_id = auth.uid()
  )
$$;

alter table public.admins enable row level security;
alter table public.orders enable row level security;
alter table public.order_items enable row level security;

revoke all on table public.admins, public.orders, public.order_items
  from anon, authenticated;

grant insert on table public.orders to anon;
grant insert on table public.order_items to anon;

grant select, update, delete on table public.orders to authenticated;
grant select, update, delete on table public.order_items to authenticated;

grant usage, select on sequence public.order_items_id_seq
  to anon, authenticated;

create policy "public_can_create_orders"
on public.orders
for insert
to anon
with check (true);

create policy "public_can_create_order_items"
on public.order_items
for insert
to anon
with check (true);

create policy "admins_manage_orders"
on public.orders
for all
to authenticated
using ((select public.is_admin()))
with check ((select public.is_admin()));

create policy "admins_manage_order_items"
on public.order_items
for all
to authenticated
using ((select public.is_admin()))
with check ((select public.is_admin()));