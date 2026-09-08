-- Categorías, unidades de venta y fotos para el catálogo.
-- Pegá este bloque en Supabase > SQL Editor > New query > Run.

alter table public.products
  add column if not exists category text not null default 'Verduras',
  add column if not exists sale_unit text not null default 'kg',
  add column if not exists image_url text;

alter table public.products
  drop constraint if exists products_sale_unit_check;

alter table public.products
  add constraint products_sale_unit_check
  check (sale_unit in ('kg', 'unidad', 'docena'));

alter table public.order_items
  add column if not exists sale_unit text not null default 'kg';

alter table public.order_items
  drop constraint if exists order_items_sale_unit_check;

alter table public.order_items
  add constraint order_items_sale_unit_check
  check (sale_unit in ('kg', 'unidad', 'docena'));

insert into storage.buckets (id, name, public)
values ('product-images', 'product-images', true)
on conflict (id) do nothing;

create policy "admins_upload_product_images"
on storage.objects for insert to authenticated
with check (bucket_id = 'product-images' and (select public.is_admin()));

create policy "admins_update_product_images"
on storage.objects for update to authenticated
using (bucket_id = 'product-images' and (select public.is_admin()))
with check (bucket_id = 'product-images' and (select public.is_admin()));

create policy "admins_delete_product_images"
on storage.objects for delete to authenticated
using (bucket_id = 'product-images' and (select public.is_admin()));
