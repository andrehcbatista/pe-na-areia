# Pé na Areia - Modelagem Conceitual Inicial de Dados

## Aviso inicial

Esta é uma modelagem conceitual inicial para o backend futuro do Pé na Areia.

Nenhuma tabela foi criada ainda. O projeto continua mockado no MVP 1, sem Supabase implementado, sem backend real e sem alteração no código Flutter.

Este documento serve como base de planejamento para uma futura implementação em Supabase/PostgreSQL.

## Contexto do produto

O Pé na Areia é uma plataforma mobile/web para descoberta e consumo em bares de praia. A praia-piloto é Boa Viagem, Recife/PE.

No futuro, a plataforma poderá incluir perfis, autenticação, estabelecimentos, cardápios, conjuntos físicos, QR Code, pedidos, comandas, pagamentos, cashback, reservas, avaliações e operação administrativa.

## Perfis futuros

### visitor

Perfil público, sem registro. Pode consultar dados públicos de praias, estabelecimentos aprovados, cardápios públicos, status, disponibilidade e mapa/lista.

### customer

Consumidor autenticado. Poderá usar funcionalidades futuras como pedidos, comandas, pagamentos, cashback interno, reservas, avaliações e histórico.

### establishment_owner

Responsável principal por um estabelecimento. Poderá gerenciar dados do próprio estabelecimento, equipe, cardápio, conjuntos, pedidos, comandas e operação futura.

### establishment_staff

Membro operacional vinculado a um estabelecimento. Poderá acessar apenas funções autorizadas do próprio estabelecimento, como acompanhar pedidos, comandas e disponibilidade.

### platform_admin

Administrador da plataforma. Poderá aprovar estabelecimentos, gerenciar cadastros, moderar conteúdos, auditar a operação e acessar dados necessários para suporte e governança.

## Entidades principais

### profiles

Finalidade: representar usuários autenticados e seus perfis futuros na plataforma.

Campos principais: id, auth_user_id, full_name, phone, email, role, avatar_url, document_reference, status, created_at, updated_at.

Relacionamentos: pode se relacionar com establishments via establishment_members; pode ser cliente em orders, tabs, reservations, payments, cashback_credits e reviews; pode executar ações registradas em audit_logs.

Observações de negócio: visitantes não registrados não precisam de registro em profiles. Dados pessoais devem seguir LGPD. O campo role deve ser tratado com cuidado e protegido por RLS.

### beaches

Finalidade: representar praias atendidas pela plataforma.

Campos principais: id, name, city, state, country, neighborhood, latitude, longitude, status, created_at, updated_at.

Relacionamentos: uma praia possui muitos establishments.

Observações de negócio: a praia-piloto é Boa Viagem, Recife/PE. Futuras praias devem ser ativadas de forma controlada pela plataforma.

### establishments

Finalidade: representar bares, quiosques e estabelecimentos de praia.

Campos principais: id, beach_id, name, slug, description, phone, address, latitude, longitude, cover_image_url, logo_url, status, opening_hours, average_rating, created_at, updated_at.

Relacionamentos: pertence a beaches; possui establishment_members, umbrella_sets, menu_categories, menu_items, orders, tabs, reservations, payments, cashback_rules, reviews, qr_codes e audit_logs.

Observações de negócio: apenas estabelecimentos aprovados devem aparecer para visitantes. A localização usada pelo app é a do estabelecimento, não a dos conjuntos.

### establishment_members

Finalidade: vincular usuários autenticados a estabelecimentos e definir permissões operacionais.

Campos principais: id, establishment_id, profile_id, role, permissions, status, invited_at, accepted_at, created_at, updated_at.

Relacionamentos: pertence a establishments e profiles.

Observações de negócio: permite separar dono e equipe. Um usuário pode estar vinculado a mais de um estabelecimento no futuro, se isso for aprovado.

### establishment_signup_requests

Finalidade: registrar solicitações de cadastro de novos estabelecimentos.

Campos principais: id, beach_id, requester_name, requester_phone, requester_email, establishment_name, address, message, status, reviewed_by_profile_id, reviewed_at, created_at, updated_at.

Relacionamentos: pode pertencer a beaches; pode ser revisada por um profile administrador; pode originar um establishment aprovado.

Observações de negócio: no MVP 1 existe apenas fluxo mockado. No backend futuro, a aprovação deve ser feita por administradores da plataforma.

### umbrella_sets

Finalidade: representar conjuntos físicos móveis de praia, como guarda-sol, mesa e cadeiras.

Campos principais: id, establishment_id, public_code, label, description, status, capacity, current_location_note, created_at, updated_at.

Relacionamentos: pertence a establishments; pode se relacionar com qr_codes, orders, tabs e reservations.

Observações de negócio: a localização principal do app continua sendo a do estabelecimento. O conjunto é físico e móvel. O código manual será alternativa ao QR Code.

### menu_categories

Finalidade: organizar os itens do cardápio por categorias.

Campos principais: id, establishment_id, name, description, display_order, status, created_at, updated_at.

Relacionamentos: pertence a establishments; possui muitos menu_items.

Observações de negócio: categorias inativas não devem aparecer no cardápio público. A ordenação deve facilitar a exibição no app.

### menu_items

Finalidade: representar produtos do cardápio.

Campos principais: id, establishment_id, category_id, name, description, price, image_url, is_available, preparation_time_minutes, cashback_eligible, status, created_at, updated_at.

Relacionamentos: pertence a establishments e menu_categories; pode aparecer em order_items e tab_items; pode se relacionar com cashback_rules.

Observações de negócio: preços e disponibilidade devem ser controlados pelo estabelecimento. Histórico de preço pode ser necessário em fases futuras para auditoria.

### orders

Finalidade: representar pedidos feitos pelo consumidor.

Campos principais: id, establishment_id, customer_profile_id, umbrella_set_id, tab_id, order_number, type, status, subtotal_amount, discount_amount, total_amount, notes, created_at, updated_at.

Relacionamentos: pertence a establishments; pode pertencer a profiles, umbrella_sets e tabs; possui order_items; pode gerar payments, cashback_credits e audit_logs.

Observações de negócio: o pedido poderá ser direto no bar ou vinculado a um conjunto. O pedido real não faz parte do MVP 1 atual.

### order_items

Finalidade: detalhar os itens de um pedido.

Campos principais: id, order_id, menu_item_id, item_name_snapshot, unit_price_snapshot, quantity, notes, total_amount, created_at.

Relacionamentos: pertence a orders; referencia menu_items.

Observações de negócio: snapshots de nome e preço ajudam a preservar o histórico mesmo se o cardápio mudar depois.

### tabs

Finalidade: representar comandas futuras.

Campos principais: id, establishment_id, customer_profile_id, umbrella_set_id, tab_number, status, opened_at, closed_at, subtotal_amount, total_amount, created_at, updated_at.

Relacionamentos: pertence a establishments; pode pertencer a profiles e umbrella_sets; possui tab_items; pode agrupar orders e payments.

Observações de negócio: a comanda poderá ser vinculada a usuário, estabelecimento e conjunto. Regras de abertura, fechamento e pagamento devem ser definidas antes da implementação real.

### tab_items

Finalidade: registrar itens vinculados diretamente a uma comanda.

Campos principais: id, tab_id, menu_item_id, order_item_id, item_name_snapshot, unit_price_snapshot, quantity, total_amount, created_at.

Relacionamentos: pertence a tabs; pode referenciar menu_items e order_items.

Observações de negócio: deve haver critério claro para evitar duplicidade entre itens de pedido e itens de comanda.

### reservations

Finalidade: representar reservas futuras de conjuntos ou experiências vinculadas a estabelecimentos.

Campos principais: id, establishment_id, customer_profile_id, umbrella_set_id, reservation_date, start_time, end_time, party_size, status, minimum_credit_amount, check_in_at, cancelled_at, created_at, updated_at.

Relacionamentos: pertence a establishments e profiles; pode se relacionar com umbrella_sets, payments, cashback_credits e audit_logs.

Observações de negócio: reserva será fase posterior, com crédito mínimo e check-in. Regras de no-show, cancelamento e tolerância precisam ser definidas.

### payments

Finalidade: registrar pagamentos futuros processados pela plataforma.

Campos principais: id, establishment_id, customer_profile_id, order_id, tab_id, reservation_id, provider, provider_payment_id, method, status, gross_amount, platform_fee_amount, establishment_amount, paid_at, created_at, updated_at.

Relacionamentos: pertence a establishments; pode pertencer a profiles; pode se vincular a orders, tabs e reservations.

Observações de negócio: pagamentos serão processados pela plataforma futuramente. Integração com split será definida depois. Dados financeiros exigem controles fortes de segurança e auditoria.

### cashback_rules

Finalidade: definir regras de cashback interno aplicáveis a estabelecimentos, itens ou campanhas.

Campos principais: id, establishment_id, menu_item_id, name, description, percentage, fixed_amount, starts_at, ends_at, status, created_at, updated_at.

Relacionamentos: pode pertencer a establishments e menu_items; pode gerar cashback_credits.

Observações de negócio: cashback será crédito interno, não dinheiro em conta bancária. Regras precisam evitar abuso e conflito entre campanhas.

### cashback_credits

Finalidade: registrar créditos internos de cashback de consumidores.

Campos principais: id, customer_profile_id, establishment_id, source_order_id, source_payment_id, amount, balance_amount, status, expires_at, created_at, updated_at.

Relacionamentos: pertence a profiles; pode pertencer a establishments; pode ser originado por orders e payments.

Observações de negócio: deve haver histórico claro de geração, uso, expiração e estorno de crédito interno.

### reviews

Finalidade: registrar avaliações bilaterais entre consumidores e estabelecimentos.

Campos principais: id, establishment_id, reviewer_profile_id, reviewed_profile_id, order_id, reservation_id, direction, rating, comment, status, created_at, updated_at.

Relacionamentos: pertence a establishments; referencia profiles; pode se relacionar com orders e reservations.

Observações de negócio: avaliações serão bilaterais. Moderação será importante para lidar com conteúdo abusivo ou falso.

### qr_codes

Finalidade: representar QR Codes vinculados a conjuntos físicos móveis.

Campos principais: id, establishment_id, umbrella_set_id, code, manual_code, status, issued_at, revoked_at, last_scanned_at, created_at, updated_at.

Relacionamentos: pertence a establishments; pertence a umbrella_sets; pode originar orders, tabs e audit_logs.

Observações de negócio: QR Code identifica o conjunto físico móvel. O código manual será alternativa. QR Codes extraviados, duplicados ou revogados devem ser tratados com cuidado.

### audit_logs

Finalidade: registrar ações relevantes para auditoria, suporte e segurança.

Campos principais: id, actor_profile_id, establishment_id, action, entity_type, entity_id, metadata, ip_address, user_agent, created_at.

Relacionamentos: pode pertencer a profiles e establishments; referencia entidades variadas por entity_type e entity_id.

Observações de negócio: ações administrativas, alterações financeiras, mudanças de permissão e moderação devem ser auditadas.

## Regras de acesso futuras

- Dados públicos de estabelecimentos aprovados podem ser vistos por visitantes.
- Consumidores veem seus próprios pedidos, comandas, pagamentos, cashback e reservas.
- Estabelecimentos veem apenas dados do próprio estabelecimento.
- Administradores da plataforma veem e gerenciam todos os dados necessários para operação, suporte, moderação e auditoria.
- RLS será obrigatória antes de produção.

## Regras de negócio importantes

- A localização usada pelo app é a do estabelecimento, não a do conjunto.
- O QR Code identifica o conjunto físico móvel.
- O código manual será alternativa ao QR Code.
- O pedido poderá ser direto no bar ou vinculado a conjunto.
- A comanda poderá ser vinculada a usuário, estabelecimento e conjunto.
- Reserva será fase posterior, com crédito mínimo e check-in.
- Cashback será crédito interno.
- Avaliações serão bilaterais.
- Pagamentos serão processados pela plataforma futuramente.
- Integração de pagamento com split será definida depois.

## Separação por fases

### Fase A: dados públicos do MVP 1 real

Criar base real para praias, estabelecimentos aprovados, cardápios públicos, status, disponibilidade e dados públicos usados hoje por mocks.

### Fase B: autenticação e perfis

Implementar autenticação, profiles, papéis básicos e políticas iniciais de acesso.

### Fase C: estabelecimento real e painel

Permitir cadastro, aprovação e gestão real de estabelecimentos e membros autorizados.

### Fase D: cardápio real

Permitir gestão real de categorias, itens, preços, imagens e disponibilidade.

### Fase E: pedidos simples

Permitir pedidos básicos vinculados a consumidor, estabelecimento e, quando aplicável, conjunto.

### Fase F: QR Code e código manual

Vincular QR Codes e códigos manuais aos conjuntos físicos móveis.

### Fase G: comanda

Criar comandas vinculadas a usuário, estabelecimento e conjunto, com abertura, acompanhamento e fechamento.

### Fase H: pagamentos e cashback

Integrar pagamentos processados pela plataforma, regras de repasse, split futuro e crédito interno de cashback.

### Fase I: reservas

Implementar reservas com crédito mínimo, check-in, cancelamento e regras de no-show.

### Fase J: ambulantes

Avaliar e modelar ambulantes em ciclo separado, pois envolvem localização, operação e regras diferentes dos estabelecimentos fixos.

## Riscos e pontos de atenção

- LGPD e tratamento de dados pessoais.
- Permissões entre perfis e separação correta de acesso.
- Dados financeiros e histórico de pagamentos.
- Repasses e split de pagamentos.
- Avaliações abusivas, falsas ou difamatórias.
- No-show em reservas.
- QR Codes extraviados, duplicados ou usados indevidamente.
- Responsabilidade fiscal dos estabelecimentos.
- Auditoria de ações administrativas.

## Próximo passo sugerido

Criar o documento `DATABASE_SCHEMA_V1.md` com uma proposta de tabelas SQL para a Fase A e Fase B, ainda sem executar nada no Supabase.
