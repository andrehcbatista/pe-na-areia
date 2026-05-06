-- Pe na Areia - Phase A seed draft for Supabase/PostgreSQL.
--
-- DRAFT - do not execute without technical, product, data, and security review.
-- This file contains fictitious data only.
-- Do not use real bar, menu, price, image, contact, or location data without authorization.
-- The current MVP 1 is still mocked and does not use a real Supabase backend.
-- This file is not an official migration.
-- This file depends on the draft schema in supabase/schema_phase_ab_draft.sql.
-- This file must not contain real personal data.
-- This file must not contain secrets, API keys, URLs, passwords, tokens, or sensitive data.
--
-- Scope:
-- - Phase A public MVP data only: beach, establishments, menu categories, menu items,
--   and aggregated availability snapshots.
-- - No login, payment, order, tab, reservation, real cashback, real QR Code,
--   real Google Maps, backend integration, or Storage setup is created here.
--
-- Idempotency approach:
-- - Fixed UUIDs are used for reviewability.
-- - Inserts use ON CONFLICT where the draft schema supports it.
-- - If rows are manually created with the same slug/name but different IDs,
--   review conflicts before executing this draft.
--
-- Fixed UUID ranges in this draft:
-- - Beach:          00000000-0000-4000-8000-000000000001
-- - Establishments: 00000000-0000-4000-8000-000000000201 through 000000000204
-- - Categories:     generated in the 000000100xxx range
-- - Menu items:     generated in the 000000200xxx range
-- - Availability:   00000000-0000-4000-8000-000000300001 through 000000300004

-- ---------------------------------------------------------------------------
-- Beach seed
-- ---------------------------------------------------------------------------

-- Coordinates are approximate for Boa Viagem and must be validated before any
-- production use.
insert into public.beaches (
  id,
  name,
  slug,
  city,
  state,
  country,
  neighborhood,
  latitude,
  longitude,
  status,
  is_active,
  created_at,
  updated_at
) values (
  '00000000-0000-4000-8000-000000000001',
  'Boa Viagem',
  'boa-viagem',
  'Recife',
  'PE',
  'Brasil',
  'Boa Viagem',
  -8.1268000,
  -34.9003000,
  'active',
  true,
  '2026-05-05 12:00:00-03',
  '2026-05-05 12:00:00-03'
)
on conflict (id) do update set
  name = excluded.name,
  slug = excluded.slug,
  city = excluded.city,
  state = excluded.state,
  country = excluded.country,
  neighborhood = excluded.neighborhood,
  latitude = excluded.latitude,
  longitude = excluded.longitude,
  status = excluded.status,
  is_active = excluded.is_active,
  updated_at = excluded.updated_at;

-- ---------------------------------------------------------------------------
-- Establishment seeds
-- ---------------------------------------------------------------------------

-- All establishments below are fictitious and created only for future internal
-- testing of public MVP 1 data.
--
-- The current schema draft does not have dedicated columns for price_range,
-- total_umbrella_sets, available_umbrella_sets, or cashback_summary.
-- Availability is seeded in establishment_availability_snapshots below.
-- Cashback appears only as non-binding preview text on menu items.
insert into public.establishments (
  id,
  beach_id,
  name,
  slug,
  description,
  operation_type,
  phone,
  address,
  reference_point,
  latitude,
  longitude,
  cover_image_url,
  logo_url,
  opening_hours,
  average_rating,
  reviews_count,
  status,
  is_active,
  created_at,
  updated_at
) values
  (
    '00000000-0000-4000-8000-000000000201',
    '00000000-0000-4000-8000-000000000001',
    'Bar Atlantico',
    'bar-atlantico',
    'Bar de praia ficticio com bebidas geladas, petiscos simples e atendimento rapido na orla. Faixa de preco mockada: media. Cashback resumo mockado: ate 5% em itens selecionados, sem cashback real.',
    'bar',
    null,
    'Endereco ficticio na orla de Boa Viagem, Recife/PE',
    'Proximo a um posto ficticio de apoio na praia',
    -8.1199000,
    -34.8958000,
    null,
    null,
    '{"daily": "09:00-18:00", "note": "Horario ficticio para teste"}'::jsonb,
    4.60,
    128,
    'approved',
    true,
    '2026-05-05 12:00:00-03',
    '2026-05-05 12:00:00-03'
  ),
  (
    '00000000-0000-4000-8000-000000000202',
    '00000000-0000-4000-8000-000000000001',
    'Mare Alta Beach Bar',
    'mare-alta-beach-bar',
    'Beach bar ficticio com drinks, cervejas e petiscos para testes de exibicao premium no app. Faixa de preco mockada: media-alta. Cashback resumo mockado: ate 7% em bebidas e petiscos, sem cashback real.',
    'beach_tent',
    null,
    'Trecho central ficticio da orla de Boa Viagem, Recife/PE',
    'Ponto ficticio proximo ao calcadao',
    -8.1242000,
    -34.8986000,
    null,
    null,
    '{"daily": "10:00-19:00", "note": "Horario ficticio para teste"}'::jsonb,
    4.75,
    214,
    'approved',
    true,
    '2026-05-05 12:00:00-03',
    '2026-05-05 12:00:00-03'
  ),
  (
    '00000000-0000-4000-8000-000000000203',
    '00000000-0000-4000-8000-000000000001',
    'Barraca Coqueiral',
    'barraca-coqueiral',
    'Barraca ficticia com agua de coco, queijo coalho, porcoes e estrutura basica de praia. Faixa de preco mockada: economica. Cashback resumo mockado: ate 3% em produtos selecionados, sem cashback real.',
    'beach_tent',
    null,
    'Ponto ficticio no calcadao de Boa Viagem, Recife/PE',
    'Area ficticia com coqueiros proximos',
    -8.1287000,
    -34.9024000,
    null,
    null,
    '{"daily": "08:30-17:30", "note": "Horario ficticio para teste"}'::jsonb,
    4.30,
    76,
    'approved',
    true,
    '2026-05-05 12:00:00-03',
    '2026-05-05 12:00:00-03'
  ),
  (
    '00000000-0000-4000-8000-000000000204',
    '00000000-0000-4000-8000-000000000001',
    'Orla Premium',
    'orla-premium',
    'Estabelecimento ficticio com proposta mais sofisticada, frutos do mar e estrutura ampliada. Faixa de preco mockada: alta. Cashback resumo mockado: ate 10% em itens selecionados, sem cashback real.',
    'beach_restaurant',
    null,
    'Area ficticia de maior estrutura na orla de Boa Viagem, Recife/PE',
    'Referencia ficticia proxima a um acesso principal da praia',
    -8.1322000,
    -34.9041000,
    null,
    null,
    '{"daily": "10:00-21:00", "note": "Horario ficticio para teste"}'::jsonb,
    4.85,
    302,
    'approved',
    true,
    '2026-05-05 12:00:00-03',
    '2026-05-05 12:00:00-03'
  )
on conflict (id) do update set
  beach_id = excluded.beach_id,
  name = excluded.name,
  slug = excluded.slug,
  description = excluded.description,
  operation_type = excluded.operation_type,
  phone = excluded.phone,
  address = excluded.address,
  reference_point = excluded.reference_point,
  latitude = excluded.latitude,
  longitude = excluded.longitude,
  cover_image_url = excluded.cover_image_url,
  logo_url = excluded.logo_url,
  opening_hours = excluded.opening_hours,
  average_rating = excluded.average_rating,
  reviews_count = excluded.reviews_count,
  status = excluded.status,
  is_active = excluded.is_active,
  updated_at = excluded.updated_at;

-- ---------------------------------------------------------------------------
-- Menu category seeds
-- ---------------------------------------------------------------------------

-- Categories are duplicated per establishment because the schema draft links
-- menu_categories directly to establishments.
with seed_establishments(seed_code, establishment_id) as (
  values
    (1, '00000000-0000-4000-8000-000000000201'::uuid),
    (2, '00000000-0000-4000-8000-000000000202'::uuid),
    (3, '00000000-0000-4000-8000-000000000203'::uuid),
    (4, '00000000-0000-4000-8000-000000000204'::uuid)
),
seed_categories(display_order, name, description) as (
  values
    (1, 'Bebidas', 'Bebidas nao alcoolicas em geral.'),
    (2, 'Cervejas', 'Cervejas em lata, long neck ou similares.'),
    (3, 'Drinks', 'Drinks com ou sem alcool.'),
    (4, 'Petiscos', 'Porcoes e itens rapidos.'),
    (5, 'Frutos do mar', 'Itens de peixe, camarao e similares.'),
    (6, 'Refeicoes', 'Pratos principais e refeicoes completas.'),
    (7, 'Sobremesas', 'Itens doces.'),
    (8, 'Estrutura', 'Itens ligados a guarda-sol, cadeira e apoio de praia.')
)
insert into public.menu_categories (
  id,
  establishment_id,
  name,
  description,
  display_order,
  is_active,
  created_at,
  updated_at
)
select
  (
    '00000000-0000-4000-8000-'
    || lpad((100000 + seed_establishments.seed_code * 100 + seed_categories.display_order)::text, 12, '0')
  )::uuid as id,
  seed_establishments.establishment_id,
  seed_categories.name,
  seed_categories.description,
  seed_categories.display_order,
  true,
  '2026-05-05 12:00:00-03'::timestamptz,
  '2026-05-05 12:00:00-03'::timestamptz
from seed_establishments
cross join seed_categories
on conflict (id) do update set
  establishment_id = excluded.establishment_id,
  name = excluded.name,
  description = excluded.description,
  display_order = excluded.display_order,
  is_active = excluded.is_active,
  updated_at = excluded.updated_at;

-- ---------------------------------------------------------------------------
-- Menu item seeds
-- ---------------------------------------------------------------------------

-- The schema draft does not have brand or cashback_percent columns.
-- Brand is included only as public description text when useful.
-- Cashback is included only in cashback_preview_text and is not real cashback.
with seed_establishments(seed_code, establishment_id, establishment_slug, price_delta_cents) as (
  values
    (1, '00000000-0000-4000-8000-000000000201'::uuid, 'bar-atlantico', 0),
    (2, '00000000-0000-4000-8000-000000000202'::uuid, 'mare-alta-beach-bar', 200),
    (3, '00000000-0000-4000-8000-000000000203'::uuid, 'barraca-coqueiral', -100),
    (4, '00000000-0000-4000-8000-000000000204'::uuid, 'orla-premium', 500)
),
seed_products(display_order, category_name, name, base_price_cents, description, brand_note, cashback_percent, preparation_time_minutes) as (
  values
    (1, 'Bebidas', 'Agua mineral 500ml', 500, 'Garrafa individual de agua mineral sem gas.', null, 0, 2),
    (2, 'Bebidas', 'Coca-Cola lata', 700, 'Refrigerante em lata de 350ml.', 'Coca-Cola', 0, 2),
    (3, 'Bebidas', 'Agua de coco', 800, 'Agua de coco servida gelada.', null, 0, 3),
    (4, 'Cervejas', 'Heineken long neck', 1400, 'Cerveja long neck de 330ml.', 'Heineken', 3, 2),
    (5, 'Cervejas', 'Brahma lata', 800, 'Cerveja em lata de 350ml.', 'Brahma', 2, 2),
    (6, 'Petiscos', 'Queijo coalho', 1200, 'Espeto de queijo coalho assado.', null, 2, 10),
    (7, 'Petiscos', 'Batata frita', 2800, 'Porcao de batata frita para compartilhar.', null, 3, 18),
    (8, 'Frutos do mar', 'Camarao alho e oleo', 6800, 'Porcao de camarao no alho e oleo.', null, 5, 25),
    (9, 'Frutos do mar', 'Isca de peixe', 4500, 'Porcao de iscas de peixe empanadas.', null, 4, 22),
    (10, 'Estrutura', 'Conjunto guarda-sol + 2 cadeiras', 3500, 'Uso de um guarda-sol com duas cadeiras por periodo definido pelo estabelecimento. Nao representa reserva real.', null, 0, null)
)
insert into public.menu_items (
  id,
  establishment_id,
  category_id,
  name,
  description,
  price_cents,
  image_url,
  status,
  is_active,
  display_order,
  preparation_time_minutes,
  cashback_preview_text,
  created_at,
  updated_at
)
select
  (
    '00000000-0000-4000-8000-'
    || lpad((200000 + seed_establishments.seed_code * 100 + seed_products.display_order)::text, 12, '0')
  )::uuid as id,
  seed_establishments.establishment_id,
  menu_categories.id as category_id,
  seed_products.name,
  seed_products.description
    || case
      when seed_products.brand_note is null then ''
      else ' Marca/observacao: ' || seed_products.brand_note || '.'
    end
    || ' Preco ficticio para teste; validar antes de qualquer uso real.' as description,
  greatest(seed_products.base_price_cents + seed_establishments.price_delta_cents, 0) as price_cents,
  null as image_url,
  case
    when seed_establishments.establishment_slug = 'bar-atlantico'
      and seed_products.name = 'Conjunto guarda-sol + 2 cadeiras'
      then 'unavailable'
    when seed_establishments.establishment_slug = 'barraca-coqueiral'
      and seed_products.name = 'Camarao alho e oleo'
      then 'unavailable'
    else 'available'
  end::menu_item_status as status,
  true as is_active,
  seed_products.display_order,
  seed_products.preparation_time_minutes,
  case
    when seed_products.cashback_percent > 0 then
      format(
        'Mock: %s%% demonstrativo em item selecionado; nao e cashback real.',
        seed_products.cashback_percent
      )
    else null
  end as cashback_preview_text,
  '2026-05-05 12:00:00-03'::timestamptz,
  '2026-05-05 12:00:00-03'::timestamptz
from seed_establishments
join seed_products on true
join public.menu_categories
  on menu_categories.establishment_id = seed_establishments.establishment_id
  and menu_categories.name = seed_products.category_name
on conflict (id) do update set
  establishment_id = excluded.establishment_id,
  category_id = excluded.category_id,
  name = excluded.name,
  description = excluded.description,
  price_cents = excluded.price_cents,
  image_url = excluded.image_url,
  status = excluded.status,
  is_active = excluded.is_active,
  display_order = excluded.display_order,
  preparation_time_minutes = excluded.preparation_time_minutes,
  cashback_preview_text = excluded.cashback_preview_text,
  updated_at = excluded.updated_at;

-- ---------------------------------------------------------------------------
-- Availability snapshot seeds
-- ---------------------------------------------------------------------------

-- These snapshots are aggregated and fictitious.
-- They do not model physical umbrella sets, QR Codes, reservations, orders, or tabs.
insert into public.establishment_availability_snapshots (
  id,
  establishment_id,
  total_sets,
  available_sets,
  occupied_sets,
  availability_label,
  source,
  is_active,
  captured_at,
  created_at
) values
  (
    '00000000-0000-4000-8000-000000300001',
    '00000000-0000-4000-8000-000000000201',
    24,
    8,
    16,
    'Media',
    'manual_mock_seed',
    true,
    '2026-05-05 12:00:00-03',
    '2026-05-05 12:00:00-03'
  ),
  (
    '00000000-0000-4000-8000-000000300002',
    '00000000-0000-4000-8000-000000000202',
    32,
    14,
    18,
    'Alta',
    'manual_mock_seed',
    true,
    '2026-05-05 12:00:00-03',
    '2026-05-05 12:00:00-03'
  ),
  (
    '00000000-0000-4000-8000-000000300003',
    '00000000-0000-4000-8000-000000000203',
    18,
    5,
    13,
    'Media',
    'manual_mock_seed',
    true,
    '2026-05-05 12:00:00-03',
    '2026-05-05 12:00:00-03'
  ),
  (
    '00000000-0000-4000-8000-000000300004',
    '00000000-0000-4000-8000-000000000204',
    40,
    20,
    20,
    'Alta',
    'manual_mock_seed',
    true,
    '2026-05-05 12:00:00-03',
    '2026-05-05 12:00:00-03'
  )
on conflict (id) do update set
  establishment_id = excluded.establishment_id,
  total_sets = excluded.total_sets,
  available_sets = excluded.available_sets,
  occupied_sets = excluded.occupied_sets,
  availability_label = excluded.availability_label,
  source = excluded.source,
  is_active = excluded.is_active,
  captured_at = excluded.captured_at;

-- ---------------------------------------------------------------------------
-- Final review notes
-- ---------------------------------------------------------------------------

-- Real seeds must be reviewed before execution.
-- Real establishment data requires explicit authorization from each establishment.
-- Real prices require validation with the establishments before publication.
-- Real images must be handled through Supabase Storage in a separate reviewed cycle.
-- Do not treat cashback_preview_text as real cashback, credit, discount, or payment logic.
-- Do not execute this file as a production migration.
