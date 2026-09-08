-- Catálogo editable de Buenasraíces.
-- Pegá este bloque completo en Supabase > SQL Editor > New query > Run.

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null unique check (char_length(name) between 2 and 100),
  icon text not null default '🌿',
  price_per_kg numeric(12,2) not null check (price_per_kg >= 0),
  active boolean not null default true,
  display_order integer not null default 0,
  created_at timestamptz not null default now()
);

insert into public.products (name, icon, price_per_kg, display_order)
values
  ('Tomate redondo', '🍅', 2800, 1),
  ('Zanahoria', '🥕', 1500, 2),
  ('Papa agroecológica', '🥔', 1300, 3),
  ('Lechuga mantecosa', '🥬', 1800, 4),
  ('Manzana roja', '🍎', 2600, 5),
  ('Banana', '🍌', 2200, 6)
on conflict (name) do nothing;

alter table public.products enable row level security;
revoke all on table public.products from anon, authenticated;
grant select on table public.products to anon;
grant select, insert, update, delete on table public.products to authenticated;

create policy "public_can_view_active_products"
on public.products for select to anon
using (active = true);

create policy "admins_manage_products"
on public.products for all to authenticated
using ((select public.is_admin()))
with check ((select public.is_admin()));
