-- ============================================================
-- PRAKTIK 5: TABEL KOS DENGAN OWNER_ID & ROW LEVEL SECURITY (RLS)
-- ============================================================

-- 1. Buat tabel kos
create table if not exists public.kos (
  id         uuid primary key default gen_random_uuid(),
  owner_id   uuid not null default auth.uid()
             references auth.users(id) on delete cascade,
  name       text not null,
  address    text,
  price      integer,
  created_at timestamptz not null default now()
);

-- 2. Aktifkan Row Level Security (RLS) pada tabel kos
alter table public.kos enable row level security;

-- 3. Policy SELECT: Semua user terautentikasi (seeker & owner) boleh melihat daftar kos
drop policy if exists "kos_select_authenticated" on public.kos;
create policy "kos_select_authenticated"
  on public.kos for select to authenticated
  using (true);

-- 4. Policy INSERT: Hanya user dengan role 'owner' atau 'admin' yang boleh menambah kos,
--    dan owner_id harus sama dengan id akun yang sedang login
drop policy if exists "kos_insert_owner" on public.kos;
create policy "kos_insert_owner"
  on public.kos for insert to authenticated
  with check (
    auth.uid() = owner_id
    and exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role in ('owner', 'admin')
    )
  );

-- 5. Policy UPDATE: Hanya pemilik kos (owner_id = auth.uid()) yang boleh mengedit data kos miliknya
drop policy if exists "kos_update_own" on public.kos;
create policy "kos_update_own"
  on public.kos for update to authenticated
  using (auth.uid() = owner_id)
  with check (auth.uid() = owner_id);

-- 6. Policy DELETE: Hanya pemilik kos (owner_id = auth.uid()) yang boleh menghapus data kos miliknya
drop policy if exists "kos_delete_own" on public.kos;
create policy "kos_delete_own"
  on public.kos for delete to authenticated
  using (auth.uid() = owner_id);

-- 7. Policy Admin (Opsional): Admin dapat mengelola seluruh data kos
create or replace function public.is_admin()
returns boolean
language sql stable
security definer set search_path = public
as $$
  select exists (
    select 1 from public.profiles
    where id = auth.uid() and role = 'admin'
  );
$$;

drop policy if exists "kos_admin_all" on public.kos;
create policy "kos_admin_all"
  on public.kos for all to authenticated
  using (public.is_admin())
  with check (public.is_admin());

-- 8. Verifikasi policy yang aktif (Query pengecekan)
select tablename, policyname, cmd
from pg_policies
where schemaname = 'public' and tablename = 'kos';

select relname, relrowsecurity
from pg_class
where relname = 'kos';
