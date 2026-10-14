-- Opianarium: таблица для облачной синхронизации (запусти в Supabase → SQL Editor)
create table if not exists public.budgets (
  user_id uuid primary key references auth.users(id) on delete cascade,
  payload jsonb not null,
  ts bigint not null default 0,
  updated_at timestamptz not null default now()
);

alter table public.budgets enable row level security;

-- Каждый видит и меняет только свою запись.
create policy "own row select" on public.budgets for select using (auth.uid() = user_id);
create policy "own row insert" on public.budgets for insert with check (auth.uid() = user_id);
create policy "own row update" on public.budgets for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own row delete" on public.budgets for delete using (auth.uid() = user_id);
