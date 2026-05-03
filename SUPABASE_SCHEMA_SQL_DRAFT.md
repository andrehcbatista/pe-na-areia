# Pe na Areia - Rascunho SQL inicial para Supabase

## Aviso inicial

Este arquivo e apenas um rascunho tecnico para revisao futura.

- Nao executar este SQL sem revisao tecnica, de produto e de seguranca.
- Nenhuma tabela foi criada ainda.
- O app continua mockado no MVP 1.
- Este arquivo nao e uma migration oficial.
- Este arquivo nao implementa Supabase, backend, login, pedido, pagamento, reserva, comanda, cashback real ou integracoes externas.

## Contexto

O Pe na Areia e uma plataforma mobile/web para descoberta e consumo em bares de praia. A praia-piloto e Boa Viagem, Recife/PE.

Este rascunho cobre apenas:

- Fase A: dados publicos reais do MVP 1.
- Fase B: base inicial para autenticacao futura, perfis, solicitacoes de cadastro de estabelecimento, membros e auditoria basica.

## Pre-requisitos SQL sugeridos

Antes de qualquer execucao real, revisar estes pontos no projeto Supabase:

- Usar UUIDs com `gen_random_uuid()`, normalmente disponivel via extensao `pgcrypto` no Supabase/PostgreSQL.
- Relacionar `profiles.auth_user_id` futuramente com `auth.users(id)`, tabela gerenciada pelo Supabase Auth.
- Definir um padrao unico para `updated_at`, preferencialmente com trigger `set_updated_at()` em ciclo proprio.
- Ativar e revisar Row Level Security antes de inserir ou expor dados reais.
- Revisar Storage/buckets antes de usar URLs reais de imagens.

```sql
-- RASCUNHO. Nao executar sem revisao.
create extension if not exists pgcrypto;
```

## Tipos/enums propostos

Estes enums organizam os principais status iniciais. Antes de executar, validar se todos os nomes e valores estao alinhados com o produto.

```sql
-- RASCUNHO. Nao executar sem revisao.
do $$
begin
  if not exists (select 1 from pg_type where typname = 'beach_status') then
    create type beach_status as enum ('active', 'inactive');
  end if;

  if not exists (select 1 from pg_type where typname = 'establishment_status') then
    create type establishment_status as enum ('pending', 'approved', 'rejected', 'suspended', 'inactive');
  end if;

  if not exists (select 1 from pg_type where typname = 'signup_request_status') then
    create type signup_request_status as enum ('pending', 'approved', 'rejected');
  end if;

  if not exists (select 1 from pg_type where typname = 'profile_role') then
    create type profile_role as enum ('customer', 'establishment_owner', 'establishment_staff', 'platform_admin');
  end if;

  if not exists (select 1 from pg_type where typname = 'operation_type') then
    create type operation_type as enum ('bar', 'beach_tent', 'beach_restaurant', 'kiosk');
  end if;

  if not exists (select 1 from pg_type where typname = 'menu_item_status') then
    create type menu_item_status as enum ('available', 'unavailable');
  end if;
end $$;
```

## Fase A - Tabelas publicas do MVP 1 real

### beaches

Representa praias atendidas pela plataforma. A primeira praia prevista e Boa Viagem, Recife/PE.

```sql
-- RASCUNHO. Nao executar sem revisao.
create table if not exists public.beaches (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text not null,
  city text not null,
  state text not null,
  country text not null default 'Brasil',
  neighborhood text,
  latitude numeric(10, 7),
  longitude numeric(10, 7),
  status beach_status not null default 'active',
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint beaches_slug_unique unique (slug),
  constraint beaches_name_city_state_unique unique (name, city, state),
  constraint beaches_latitude_check check (latitude is null or latitude between -90 and 90),
  constraint beaches_longitude_check check (longitude is null or longitude between -180 and 180)
);
```

### establishments

Representa estabelecimentos de praia. Visitantes devem ver apenas estabelecimentos aprovados, ativos e vinculados a praias ativas.

```sql
-- RASCUNHO. Nao executar sem revisao.
create table if not exists public.establishments (
  id uuid primary key default gen_random_uuid(),
  beach_id uuid not null references public.beaches(id) on delete restrict,
  name text not null,
  slug text not null,
  description text,
  operation_type operation_type not null,
  phone text,
  address text,
  reference_point text,
  latitude numeric(10, 7),
  longitude numeric(10, 7),
  cover_image_url text,
  logo_url text,
  opening_hours jsonb,
  average_rating numeric(3, 2),
  reviews_count integer not null default 0,
  status establishment_status not null default 'pending',
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint establishments_slug_unique unique (slug),
  constraint establishments_rating_check check (average_rating is null or average_rating between 0 and 5),
  constraint establishments_reviews_count_check check (reviews_count >= 0),
  constraint establishments_latitude_check check (latitude is null or latitude between -90 and 90),
  constraint establishments_longitude_check check (longitude is null or longitude between -180 and 180)
);
```

### establishment_photos

Guarda referencias de fotos publicas dos estabelecimentos. A decisao sobre Supabase Storage deve ser feita antes do uso real.

```sql
-- RASCUNHO. Nao executar sem revisao.
create table if not exists public.establishment_photos (
  id uuid primary key default gen_random_uuid(),
  establishment_id uuid not null references public.establishments(id) on delete cascade,
  url text not null,
  alt_text text,
  display_order integer not null default 0,
  is_cover boolean not null default false,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint establishment_photos_display_order_check check (display_order >= 0)
);
```

### menu_categories

Organiza o cardapio publico por categorias.

```sql
-- RASCUNHO. Nao executar sem revisao.
create table if not exists public.menu_categories (
  id uuid primary key default gen_random_uuid(),
  establishment_id uuid not null references public.establishments(id) on delete cascade,
  name text not null,
  description text,
  display_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint menu_categories_establishment_name_unique unique (establishment_id, name),
  constraint menu_categories_display_order_check check (display_order >= 0)
);
```

### menu_items

Representa produtos do cardapio publico. Cashback real nao entra neste rascunho.

```sql
-- RASCUNHO. Nao executar sem revisao.
create table if not exists public.menu_items (
  id uuid primary key default gen_random_uuid(),
  establishment_id uuid not null references public.establishments(id) on delete cascade,
  category_id uuid not null references public.menu_categories(id) on delete restrict,
  name text not null,
  description text,
  price_cents integer not null,
  image_url text,
  status menu_item_status not null default 'available',
  is_active boolean not null default true,
  display_order integer not null default 0,
  preparation_time_minutes integer,
  cashback_preview_text text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint menu_items_price_cents_check check (price_cents >= 0),
  constraint menu_items_display_order_check check (display_order >= 0),
  constraint menu_items_preparation_time_check check (
    preparation_time_minutes is null or preparation_time_minutes >= 0
  )
);
```

### establishment_availability_snapshots

Registra disponibilidade basica e agregada de conjuntos por estabelecimento. Nao modela cada conjunto fisico, QR Code ou codigo manual.

```sql
-- RASCUNHO. Nao executar sem revisao.
create table if not exists public.establishment_availability_snapshots (
  id uuid primary key default gen_random_uuid(),
  establishment_id uuid not null references public.establishments(id) on delete cascade,
  total_sets integer not null,
  available_sets integer not null,
  occupied_sets integer,
  availability_label text,
  source text,
  is_active boolean not null default true,
  captured_at timestamptz not null default now(),
  created_at timestamptz not null default now(),

  constraint availability_total_sets_check check (total_sets >= 0),
  constraint availability_available_sets_check check (available_sets >= 0),
  constraint availability_occupied_sets_check check (occupied_sets is null or occupied_sets >= 0),
  constraint availability_available_lte_total_check check (available_sets <= total_sets)
);
```

## Fase B - Perfis, solicitacoes, membros e auditoria

### profiles

Representa usuarios autenticados futuramente via Supabase Auth. Visitantes sem login nao precisam de registro aqui.

```sql
-- RASCUNHO. Nao executar sem revisao.
create table if not exists public.profiles (
  id uuid primary key default gen_random_uuid(),
  auth_user_id uuid not null references auth.users(id) on delete cascade,
  full_name text,
  email text,
  phone text,
  avatar_url text,
  role profile_role not null default 'customer',
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint profiles_auth_user_id_unique unique (auth_user_id),
  constraint profiles_email_unique unique (email)
);
```

### establishment_signup_requests

Registra solicitacoes de cadastro de estabelecimento. A aprovacao real deve ser feita por administracao da plataforma em ciclo proprio.

```sql
-- RASCUNHO. Nao executar sem revisao.
create table if not exists public.establishment_signup_requests (
  id uuid primary key default gen_random_uuid(),
  beach_id uuid references public.beaches(id) on delete set null,
  requester_profile_id uuid references public.profiles(id) on delete set null,
  requester_name text not null,
  requester_phone text,
  requester_email text,
  establishment_name text not null,
  operation_type operation_type,
  address text,
  reference_point text,
  message text,
  status signup_request_status not null default 'pending',
  reviewed_by_profile_id uuid references public.profiles(id) on delete set null,
  reviewed_at timestamptz,
  rejection_reason text,
  created_establishment_id uuid references public.establishments(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint signup_requests_review_check check (
    (status = 'pending' and reviewed_at is null)
    or (status in ('approved', 'rejected') and reviewed_at is not null)
  )
);
```

### establishment_members

Vincula perfis autenticados a estabelecimentos. A edicao de dados pelo estabelecimento sera definida depois, com RLS propria.

```sql
-- RASCUNHO. Nao executar sem revisao.
create table if not exists public.establishment_members (
  id uuid primary key default gen_random_uuid(),
  establishment_id uuid not null references public.establishments(id) on delete cascade,
  profile_id uuid not null references public.profiles(id) on delete cascade,
  role profile_role not null,
  permissions jsonb,
  is_active boolean not null default true,
  invited_by_profile_id uuid references public.profiles(id) on delete set null,
  invited_at timestamptz,
  accepted_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint establishment_members_unique unique (establishment_id, profile_id),
  constraint establishment_members_role_check check (role in ('establishment_owner', 'establishment_staff'))
);
```

### audit_logs

Registra acoes relevantes para auditoria basica. Evitar guardar dados pessoais desnecessarios ou segredos em `metadata`.

```sql
-- RASCUNHO. Nao executar sem revisao.
create table if not exists public.audit_logs (
  id uuid primary key default gen_random_uuid(),
  actor_profile_id uuid references public.profiles(id) on delete set null,
  establishment_id uuid references public.establishments(id) on delete set null,
  action text not null,
  entity_type text not null,
  entity_id uuid,
  metadata jsonb,
  ip_address text,
  user_agent text,
  created_at timestamptz not null default now()
);
```

## Indices sugeridos

Estes indices devem ser revisados conforme consultas reais do app e do painel administrativo.

```sql
-- RASCUNHO. Nao executar sem revisao.

-- beaches
create index if not exists idx_beaches_status on public.beaches(status);
create index if not exists idx_beaches_is_active on public.beaches(is_active);
create index if not exists idx_beaches_slug on public.beaches(slug);

-- establishments
create index if not exists idx_establishments_beach_id on public.establishments(beach_id);
create index if not exists idx_establishments_status on public.establishments(status);
create index if not exists idx_establishments_is_active on public.establishments(is_active);
create index if not exists idx_establishments_slug on public.establishments(slug);

-- establishment_photos
create index if not exists idx_establishment_photos_establishment_id on public.establishment_photos(establishment_id);
create index if not exists idx_establishment_photos_is_active on public.establishment_photos(is_active);

-- menu_categories
create index if not exists idx_menu_categories_establishment_id on public.menu_categories(establishment_id);
create index if not exists idx_menu_categories_is_active on public.menu_categories(is_active);

-- menu_items
create index if not exists idx_menu_items_establishment_id on public.menu_items(establishment_id);
create index if not exists idx_menu_items_category_id on public.menu_items(category_id);
create index if not exists idx_menu_items_status on public.menu_items(status);
create index if not exists idx_menu_items_is_active on public.menu_items(is_active);

-- establishment_availability_snapshots
create index if not exists idx_availability_establishment_id on public.establishment_availability_snapshots(establishment_id);
create index if not exists idx_availability_is_active on public.establishment_availability_snapshots(is_active);
create index if not exists idx_availability_captured_at on public.establishment_availability_snapshots(captured_at desc);

-- profiles
create index if not exists idx_profiles_auth_user_id on public.profiles(auth_user_id);
create index if not exists idx_profiles_role on public.profiles(role);
create index if not exists idx_profiles_is_active on public.profiles(is_active);

-- establishment_signup_requests
create index if not exists idx_signup_requests_beach_id on public.establishment_signup_requests(beach_id);
create index if not exists idx_signup_requests_status on public.establishment_signup_requests(status);
create index if not exists idx_signup_requests_created_establishment_id on public.establishment_signup_requests(created_establishment_id);

-- establishment_members
create index if not exists idx_establishment_members_establishment_id on public.establishment_members(establishment_id);
create index if not exists idx_establishment_members_profile_id on public.establishment_members(profile_id);
create index if not exists idx_establishment_members_is_active on public.establishment_members(is_active);

-- audit_logs
create index if not exists idx_audit_logs_actor_profile_id on public.audit_logs(actor_profile_id);
create index if not exists idx_audit_logs_establishment_id on public.audit_logs(establishment_id);
create index if not exists idx_audit_logs_entity on public.audit_logs(entity_type, entity_id);
create index if not exists idx_audit_logs_created_at on public.audit_logs(created_at desc);
```

## RLS conceitual

Nao criar policies reais neste rascunho. RLS deve ser planejada e implementada em ciclo proprio, depois da revisao do schema.

Regras esperadas:

- Visitantes podem ler praias ativas.
- Visitantes podem ler estabelecimentos aprovados e ativos.
- Visitantes podem ler fotos, categorias, itens de cardapio e disponibilidade publica de estabelecimentos aprovados.
- Usuarios autenticados podem ver seu proprio `profile`.
- Usuarios autenticados nao podem alterar livremente seu proprio `role`.
- Membros de estabelecimento poderao ver e alterar dados do proprio estabelecimento futuramente, conforme permissoes.
- `platform_admin` pode gerenciar dados mestres.
- `audit_logs` devem ter leitura restrita a administradores da plataforma ou processos internos autorizados.

Pseudocodigo conceitual, nao executavel:

```sql
-- NAO EXECUTAR.
-- enable row level security on public.beaches;
-- policy: public select where status = 'active' and is_active = true;

-- enable row level security on public.establishments;
-- policy: public select where status = 'approved' and is_active = true;

-- enable row level security on public.menu_items;
-- policy: public select only items from approved and active establishments;

-- enable row level security on public.profiles;
-- policy: authenticated user can select/update allowed fields where auth.uid() = auth_user_id;

-- enable row level security on public.establishment_members;
-- policy: active members can access records from their own establishment;

-- enable row level security on public.audit_logs;
-- policy: platform_admin only;
```

## Dados seed conceituais

Nao criar seeds reais neste rascunho. Seeds devem ser feitos em ciclo separado, depois da revisao do schema e da RLS.

Dados conceituais iniciais:

- Praia: Boa Viagem, Recife/PE, Brasil.
- Estabelecimentos: exemplos equivalentes aos dados mockados atuais do MVP 1.
- Fotos: imagens publicas dos estabelecimentos aprovados, se houver permissao de uso.
- Categorias de cardapio: categorias equivalentes ao mock atual.
- Produtos: produtos publicos equivalentes ao mock atual.
- Disponibilidade: snapshots basicos para representar a disponibilidade exibida no MVP 1.

Observacoes:

- Os nomes finais dos estabelecimentos devem ser revisados antes de seed real.
- URLs de imagens devem ser revisadas antes de seed real.
- Dados pessoais, telefones e e-mails nao devem ser inventados nem publicados sem permissao.

## Pontos pendentes antes de executar

- Validar nomes de tabelas.
- Validar enums.
- Decidir login inicial.
- Definir se `establishment_status = 'pending'` sera usado em `establishments` ou apenas em `establishment_signup_requests`.
- Definir se `reviews_summary` sera tabela ou view futura.
- Definir Storage/buckets.
- Revisar LGPD.
- Revisar permissoes RLS.
- Revisar campos publicos vs administrativos.
- Decidir padrao definitivo de `updated_at` e triggers.
- Confirmar se `profiles.role` sera suficiente no inicio ou se sera necessario permitir multiplos papeis por usuario.
- Confirmar campos publicos de telefone, endereco e imagens dos estabelecimentos.

## Proximo passo sugerido

Criar `SUPABASE_RLS_PLAN.md` com um plano conceitual de Row Level Security antes de qualquer execucao real no Supabase.
