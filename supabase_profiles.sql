-- ============================================================
-- PRAKTIK 3: TABEL PROFILES & TRIGGER ROLE PENGGUNA
-- ============================================================

-- 1. Buat tabel profiles yang berelasi dengan auth.users
create table if not exists public.profiles (
  id    uuid primary key references auth.users(id) on delete cascade,
  email text,
  name  text,
  role  text not null default 'seeker'
        check (role in ('seeker', 'owner', 'admin'))
);

-- 2. Aktifkan Row Level Security (RLS)
alter table public.profiles enable row level security;

-- 3. Policy: User hanya boleh membaca profil miliknya sendiri
-- Tidak ada policy UPDATE agar user tidak bisa memanipulasi role miliknya sendiri
drop policy if exists "profiles_select_own" on public.profiles;
create policy "profiles_select_own"
  on public.profiles for select to authenticated
  using (auth.uid() = id);

-- 4. Function trigger untuk menyalin data saat user baru terdaftar
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, email, name, role)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data->>'name', ''),
    case
      when new.raw_user_meta_data->>'role' in ('seeker', 'owner')
        then new.raw_user_meta_data->>'role'
      else 'seeker'
    end
  );
  return new;
end;
$$;

-- 5. Pasang trigger ke auth.users
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- 6. Buat profile otomatis untuk user yang sudah ada sebelumnya (misal krisna123@gmail.com)
insert into public.profiles (id, email, name, role)
select id, email, '', 'seeker' from auth.users
on conflict (id) do nothing;
