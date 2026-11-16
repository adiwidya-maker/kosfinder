-- ============================================================================
-- WORKSHEET 9 - SQL SETUP LENGKAP UNTUK SUPABASE
-- Jalankan seluruh query ini di Supabase Dashboard -> SQL Editor -> Run
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. TABEL PROFILES & TRIGGER ROLE (Praktik 3)
-- ----------------------------------------------------------------------------
create table if not exists public.profiles (
  id    uuid primary key references auth.users(id) on delete cascade,
  email text,
  name  text,
  role  text not null default 'seeker' check (role in ('seeker', 'owner', 'admin'))
);

alter table public.profiles enable row level security;

-- User hanya boleh membaca profil miliknya sendiri
create policy "profiles_select_own"
  on public.profiles for select to authenticated
  using (auth.uid() = id);

-- Trigger untuk membuat profil otomatis saat registrasi
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

create or replace trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- Jika ada user lama yang sudah terdaftar sebelum trigger dibuat:
insert into public.profiles (id, email, name, role)
select id, email, '', 'seeker' from auth.users
on conflict (id) do nothing;


-- ----------------------------------------------------------------------------
-- 2. TABEL KOS & ROW LEVEL SECURITY (RLS) POLICIES (Praktik 5 & 6)
-- ----------------------------------------------------------------------------
create table if not exists public.kos (
  id         uuid primary key default gen_random_uuid(),
  owner_id   uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name       text not null,
  address    text,
  price      integer,
  created_at timestamptz not null default now()
);

alter table public.kos enable row level security;

-- Policy 1: Semua user terautentikasi boleh membaca daftar kos
create policy "kos_select_authenticated"
  on public.kos for select to authenticated
  using (true);

-- Policy 2: Hanya user dengan role 'owner' atau 'admin' yang boleh menambah kos miliknya
create policy "kos_insert_owner"
  on public.kos for insert to authenticated
  with check (
    auth.uid() = owner_id
    and exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role in ('owner', 'admin')
    )
  );

-- Policy 3: Hanya pemilik kos yang boleh mengubah datanya sendiri
create policy "kos_update_own"
  on public.kos for update to authenticated
  using (auth.uid() = owner_id)
  with check (auth.uid() = owner_id);

-- Policy 4: Hanya pemilik kos yang boleh menghapus datanya sendiri
create policy "kos_delete_own"
  on public.kos for delete to authenticated
  using (auth.uid() = owner_id);


-- ----------------------------------------------------------------------------
-- 3. TABEL DEVICE TOKENS UNTUK PUSH NOTIFICATION FCM (Praktik 9)
-- ----------------------------------------------------------------------------
create table if not exists public.device_tokens (
  token      text primary key,
  user_id    uuid not null default auth.uid() references auth.users(id) on delete cascade,
  platform   text,
  updated_at timestamptz not null default now()
);

alter table public.device_tokens enable row level security;

create policy "tokens_select_own" on public.device_tokens
  for select to authenticated using (auth.uid() = user_id);

create policy "tokens_insert_own" on public.device_tokens
  for insert to authenticated with check (auth.uid() = user_id);

create policy "tokens_update_own" on public.device_tokens
  for update to authenticated
  using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "tokens_delete_own" on public.device_tokens
  for delete to authenticated using (auth.uid() = user_id);
