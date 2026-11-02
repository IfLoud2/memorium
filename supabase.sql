create table public.decks (
  id text primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name text not null,
  log jsonb not null default '{}',
  created bigint not null default 0
);

create table public.cards (
  id text primary key,
  deck_id text not null references public.decks(id) on delete cascade,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  data jsonb not null
);

create index cards_deck_idx on public.cards(deck_id);
create index cards_user_idx on public.cards(user_id);

alter table public.decks enable row level security;
alter table public.cards enable row level security;

create policy decks_own on public.decks for all
  using (user_id = auth.uid()) with check (user_id = auth.uid());

create policy cards_own on public.cards for all
  using (user_id = auth.uid()) with check (user_id = auth.uid());
