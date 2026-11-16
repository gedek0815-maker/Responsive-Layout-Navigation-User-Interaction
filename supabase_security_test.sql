-- ============================================================
-- PRAKTIK 6: SIMULASI SECURITY TESTING DARI SQL EDITOR
-- ============================================================

-- 1. Cek semua policy yang aktif di tabel kos
select tablename, policyname, cmd, permissive, roles
from pg_policies
where schemaname = 'public' and tablename = 'kos';

-- 2. Cek apakah RLS aktif (harus bernilai true)
select relname, relrowsecurity
from pg_class
where relname = 'kos';

-- 3. Simulasi serangan User B (Seeker) mencoba membajak kos milik User A (Owner)
begin;
  -- Set role seolah-olah request datang dari User B yang sudah login
  set local role authenticated;
  select set_config(
    'request.jwt.claims',
    '{"sub":"dc4bfca1-13aa-4383-815e-448c0b9bd0b0","role":"authenticated"}',
    true
  );

  -- Percobaan 1: User B mencoba UPDATE nama kos milik orang lain
  -- Expected Result: UPDATE 0 (tidak ada baris yang berubah karena ditolak oleh RLS)
  update public.kos set name = 'HACKED BY USER B' where owner_id != 'dc4bfca1-13aa-4383-815e-448c0b9bd0b0';

  -- Percobaan 2: User B mencoba DELETE kos milik orang lain
  -- Expected Result: DELETE 0 (tidak ada baris yang terhapus karena ditolak oleh RLS)
  delete from public.kos where owner_id != 'dc4bfca1-13aa-4383-815e-448c0b9bd0b0';

rollback;
