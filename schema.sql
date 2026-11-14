-- Supabase SQL Editor で一度だけ実行。RLS を必ず有効にする。
create table if not exists public.wines (
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists wines_user_id_idx on public.wines(user_id);
alter table public.wines enable row level security;
drop policy if exists "wines owner select" on public.wines;
drop policy if exists "wines owner insert" on public.wines;
drop policy if exists "wines owner update" on public.wines;
drop policy if exists "wines owner delete" on public.wines;
create policy "wines owner select" on public.wines for select to authenticated using (auth.uid() = user_id);
create policy "wines owner insert" on public.wines for insert to authenticated with check (auth.uid() = user_id);
create policy "wines owner update" on public.wines for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "wines owner delete" on public.wines for delete to authenticated using (auth.uid() = user_id);
create table if not exists public.wine_settings (
  user_id uuid primary key references auth.users(id) on delete cascade,
  metrics jsonb not null default '["果実味","酸味","渋み","ボディ","香り","余韻"]'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.wine_settings enable row level security;
drop policy if exists "settings owner select" on public.wine_settings;
drop policy if exists "settings owner insert" on public.wine_settings;
drop policy if exists "settings owner update" on public.wine_settings;
create policy "settings owner select" on public.wine_settings for select to authenticated using (auth.uid() = user_id);
create policy "settings owner insert" on public.wine_settings for insert to authenticated with check (auth.uid() = user_id);
create policy "settings owner update" on public.wine_settings for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types)
values('wine-labels','wine-labels',false,5242880,array['image/jpeg','image/png','image/webp'])
on conflict (id) do update set public = false, file_size_limit = 5242880, allowed_mime_types = excluded.allowed_mime_types;
drop policy if exists "photos owner select" on storage.objects;
drop policy if exists "photos owner insert" on storage.objects;
drop policy if exists "photos owner update" on storage.objects;
drop policy if exists "photos owner delete" on storage.objects;
-- The first storage path segment must exactly equal the signed-in user's UUID.
create policy "photos owner select" on storage.objects for select to authenticated using (bucket_id='wine-labels' and (storage.foldername(name))[1] = (select auth.uid())::text);
create policy "photos owner insert" on storage.objects for insert to authenticated with check (bucket_id='wine-labels' and (storage.foldername(name))[1] = (select auth.uid())::text);
create policy "photos owner update" on storage.objects for update to authenticated using (bucket_id='wine-labels' and (storage.foldername(name))[1] = (select auth.uid())::text) with check (bucket_id='wine-labels' and (storage.foldername(name))[1] = (select auth.uid())::text);
create policy "photos owner delete" on storage.objects for delete to authenticated using (bucket_id='wine-labels' and (storage.foldername(name))[1] = (select auth.uid())::text);
