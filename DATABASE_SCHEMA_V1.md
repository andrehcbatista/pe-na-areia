# Pe na Areia - Proposta inicial de esquema de banco V1

## Aviso inicial

Este e um documento de proposta para o backend futuro do Pe na Areia.

Nenhum SQL deve ser executado ainda. Nenhuma tabela foi criada no Supabase. O aplicativo continua mockado ate um ciclo especifico de integracao com backend ser aprovado.

Este documento serve para orientar a futura modelagem em Supabase/PostgreSQL, sem implementar Supabase, sem criar migrations e sem alterar o codigo Flutter.

## Contexto

O Pe na Areia e uma plataforma mobile/web para descoberta e consumo em bares de praia. A praia-piloto e Boa Viagem, Recife/PE.

As primeiras fases consideradas neste documento sao:

- Fase A: transformar dados publicos mockados em dados reais no banco.
- Fase B: preparar autenticacao, perfis, papeis iniciais e solicitacoes de cadastro de estabelecimento.

## Convencoes gerais

- Usar UUID como chave primaria em todas as tabelas.
- Usar `created_at` e `updated_at` em tabelas editaveis.
- Usar `deleted_at` quando fizer sentido ocultar ou desativar registros sem apagar historico.
- Usar nomes em `snake_case`.
- Usar foreign keys para preservar relacoes entre tabelas.
- Usar `status` como `text` com valores documentados, ou enum PostgreSQL em uma etapa posterior.
- Prever Row Level Security futuramente antes de expor dados reais.
- Separar dados publicos de dados administrativos quando necessario.
- Evitar modelar pedidos, pagamentos, reservas, comandas e QR Code nesta primeira proposta.
- Tratar valores financeiros em centavos quando houver necessidade futura de precisao.

## Tipos e status propostos

Estes valores podem ser implementados futuramente como `text` com validacao ou como enums PostgreSQL.

| Tipo/status | Valores propostos | Observacao |
| --- | --- | --- |
| `establishment_status` | `pending`, `approved`, `rejected`, `suspended`, `inactive` | `approved` representa estabelecimento aprovado e visivel. `inactive` e `suspended` nao devem aparecer publicamente. |
| `signup_request_status` | `pending`, `approved`, `rejected` | Usado para solicitacoes de cadastro. |
| `profile_role` | `customer`, `establishment_owner`, `establishment_staff`, `platform_admin` | Visitante sem login nao precisa de perfil. |
| `operation_type` | `bar`, `beach_tent`, `beach_restaurant`, `kiosk` | Classificacao operacional do estabelecimento. |
| `menu_item_status` | `available`, `unavailable` | Controla exibicao e disponibilidade basica do item. |
| `beach_status` | `active`, `inactive` | Apenas praias ativas devem aparecer publicamente. |
| `photo_status` | `active`, `inactive` | Fotos inativas nao devem aparecer no app. |
| `member_status` | `pending`, `active`, `inactive`, `revoked` | Usado para vinculo entre perfil e estabelecimento. |
| `audit_action_status` | `success`, `failed` | Opcional para registrar resultado de acoes auditadas. |

## Fase A - Dados publicos reais do MVP

### `beaches`

Finalidade: representar praias atendidas pela plataforma.

| Campo | Tipo sugerido | Obrigatorio | Observacao |
| --- | --- | --- | --- |
| `id` | `uuid` | Sim | Chave primaria. |
| `name` | `text` | Sim | Exemplo: Boa Viagem. |
| `slug` | `text` | Sim | Identificador amigavel para URL ou busca. |
| `city` | `text` | Sim | Exemplo: Recife. |
| `state` | `text` | Sim | Exemplo: PE. |
| `country` | `text` | Sim | Exemplo: Brasil. |
| `neighborhood` | `text` | Nao | Bairro ou regiao. |
| `latitude` | `numeric` | Nao | Coordenada aproximada da praia. |
| `longitude` | `numeric` | Nao | Coordenada aproximada da praia. |
| `status` | `text` | Sim | `active` ou `inactive`. |
| `created_at` | `timestamptz` | Sim | Data de criacao. |
| `updated_at` | `timestamptz` | Sim | Data da ultima alteracao. |
| `deleted_at` | `timestamptz` | Nao | Usado se a praia precisar ser removida logicamente. |

Chave primaria: `id`.

Chaves estrangeiras: nenhuma.

Status possiveis: `active`, `inactive`.

Observacoes de negocio:

- A praia-piloto e Boa Viagem, Recife/PE.
- Visitantes devem ler apenas praias com `status = active` e `deleted_at` vazio.
- Novas praias devem ser ativadas de forma controlada pela administracao da plataforma.

### `establishments`

Finalidade: representar bares, barracas, restaurantes de praia e quiosques aprovados ou em analise.

| Campo | Tipo sugerido | Obrigatorio | Observacao |
| --- | --- | --- | --- |
| `id` | `uuid` | Sim | Chave primaria. |
| `beach_id` | `uuid` | Sim | Referencia `beaches.id`. |
| `name` | `text` | Sim | Nome publico do estabelecimento. |
| `slug` | `text` | Sim | Identificador amigavel. |
| `description` | `text` | Nao | Texto publico curto. |
| `operation_type` | `text` | Sim | `bar`, `beach_tent`, `beach_restaurant` ou `kiosk`. |
| `phone` | `text` | Nao | Telefone publico, se aprovado para exibicao. |
| `address` | `text` | Nao | Endereco ou ponto de referencia. |
| `latitude` | `numeric` | Nao | Localizacao do estabelecimento. |
| `longitude` | `numeric` | Nao | Localizacao do estabelecimento. |
| `cover_image_url` | `text` | Nao | Imagem principal publica. |
| `logo_url` | `text` | Nao | Logo publica. |
| `opening_hours` | `jsonb` | Nao | Estrutura futura para horarios. |
| `average_rating` | `numeric` | Nao | Media futura agregada. |
| `reviews_count` | `integer` | Nao | Total futuro agregado. |
| `status` | `text` | Sim | `pending`, `approved`, `rejected`, `suspended` ou `inactive`. |
| `created_at` | `timestamptz` | Sim | Data de criacao. |
| `updated_at` | `timestamptz` | Sim | Data da ultima alteracao. |
| `deleted_at` | `timestamptz` | Nao | Remocao logica. |

Chave primaria: `id`.

Chaves estrangeiras: `beach_id` referencia `beaches.id`.

Campos obrigatorios: `id`, `beach_id`, `name`, `slug`, `operation_type`, `status`, `created_at`, `updated_at`.

Status possiveis: `pending`, `approved`, `rejected`, `suspended`, `inactive`.

Observacoes de negocio:

- Visitantes devem ver apenas estabelecimentos `approved`, vinculados a praias `active` e sem `deleted_at`.
- A localizacao considerada pelo app e a do estabelecimento, nao a dos conjuntos.
- `pending` e `rejected` servem para fluxo administrativo e nao devem aparecer publicamente.

### `establishment_photos`

Finalidade: armazenar referencias de fotos publicas de estabelecimentos.

| Campo | Tipo sugerido | Obrigatorio | Observacao |
| --- | --- | --- | --- |
| `id` | `uuid` | Sim | Chave primaria. |
| `establishment_id` | `uuid` | Sim | Referencia `establishments.id`. |
| `url` | `text` | Sim | URL da foto, possivelmente Supabase Storage no futuro. |
| `alt_text` | `text` | Nao | Descricao acessivel da imagem. |
| `display_order` | `integer` | Sim | Ordem de exibicao. |
| `is_cover` | `boolean` | Sim | Indica imagem principal. |
| `status` | `text` | Sim | `active` ou `inactive`. |
| `created_at` | `timestamptz` | Sim | Data de criacao. |
| `updated_at` | `timestamptz` | Sim | Data da ultima alteracao. |
| `deleted_at` | `timestamptz` | Nao | Remocao logica. |

Chave primaria: `id`.

Chaves estrangeiras: `establishment_id` referencia `establishments.id`.

Campos obrigatorios: `id`, `establishment_id`, `url`, `display_order`, `is_cover`, `status`, `created_at`, `updated_at`.

Status possiveis: `active`, `inactive`.

Observacoes de negocio:

- Fotos so devem aparecer publicamente quando o estabelecimento estiver `approved`.
- Antes de executar SQL, decidir se as fotos ficarao no Supabase Storage desde o inicio.

### `menu_categories`

Finalidade: organizar o cardapio publico por categorias.

| Campo | Tipo sugerido | Obrigatorio | Observacao |
| --- | --- | --- | --- |
| `id` | `uuid` | Sim | Chave primaria. |
| `establishment_id` | `uuid` | Sim | Referencia `establishments.id`. |
| `name` | `text` | Sim | Nome da categoria. |
| `description` | `text` | Nao | Texto opcional. |
| `display_order` | `integer` | Sim | Ordem de exibicao. |
| `is_active` | `boolean` | Sim | Controla exibicao publica. |
| `created_at` | `timestamptz` | Sim | Data de criacao. |
| `updated_at` | `timestamptz` | Sim | Data da ultima alteracao. |
| `deleted_at` | `timestamptz` | Nao | Remocao logica. |

Chave primaria: `id`.

Chaves estrangeiras: `establishment_id` referencia `establishments.id`.

Campos obrigatorios: `id`, `establishment_id`, `name`, `display_order`, `is_active`, `created_at`, `updated_at`.

Status possiveis: nao usa `status`; usa `is_active`.

Observacoes de negocio:

- Categorias inativas ou removidas nao devem aparecer no cardapio publico.
- A ordenacao deve ser simples para facilitar exibicao no app.

### `menu_items`

Finalidade: representar produtos publicos do cardapio.

| Campo | Tipo sugerido | Obrigatorio | Observacao |
| --- | --- | --- | --- |
| `id` | `uuid` | Sim | Chave primaria. |
| `establishment_id` | `uuid` | Sim | Referencia `establishments.id`. |
| `category_id` | `uuid` | Sim | Referencia `menu_categories.id`. |
| `name` | `text` | Sim | Nome do produto. |
| `description` | `text` | Nao | Descricao publica. |
| `price_cents` | `integer` | Sim | Preco em centavos. |
| `image_url` | `text` | Nao | Imagem do produto. |
| `status` | `text` | Sim | `available` ou `unavailable`. |
| `display_order` | `integer` | Sim | Ordem dentro da categoria. |
| `preparation_time_minutes` | `integer` | Nao | Estimativa opcional. |
| `cashback_preview_text` | `text` | Nao | Texto apenas informativo enquanto nao houver cashback real. |
| `created_at` | `timestamptz` | Sim | Data de criacao. |
| `updated_at` | `timestamptz` | Sim | Data da ultima alteracao. |
| `deleted_at` | `timestamptz` | Nao | Remocao logica. |

Chave primaria: `id`.

Chaves estrangeiras:

- `establishment_id` referencia `establishments.id`.
- `category_id` referencia `menu_categories.id`.

Campos obrigatorios: `id`, `establishment_id`, `category_id`, `name`, `price_cents`, `status`, `display_order`, `created_at`, `updated_at`.

Status possiveis: `available`, `unavailable`.

Observacoes de negocio:

- Produtos indisponiveis podem aparecer como indisponiveis ou ser ocultados, conforme decisao de produto.
- Cashback real nao entra nesta fase. Qualquer texto de cashback aqui deve ser apenas informativo/mockado ate fase especifica.
- Historico de preco pode ser necessario em fases futuras de pedidos, mas nao entra neste schema inicial.

### `establishment_availability_snapshots`

Finalidade: registrar uma disponibilidade basica e publica de conjuntos por estabelecimento, sem modelar cada conjunto fisico individualmente.

| Campo | Tipo sugerido | Obrigatorio | Observacao |
| --- | --- | --- | --- |
| `id` | `uuid` | Sim | Chave primaria. |
| `establishment_id` | `uuid` | Sim | Referencia `establishments.id`. |
| `total_sets` | `integer` | Sim | Total informado de conjuntos. |
| `available_sets` | `integer` | Sim | Quantidade disponivel no momento do snapshot. |
| `occupied_sets` | `integer` | Nao | Quantidade ocupada, se houver controle. |
| `availability_label` | `text` | Nao | Texto publico curto, como "Alta", "Media" ou "Baixa". |
| `source` | `text` | Nao | Origem da informacao: admin, estabelecimento ou importacao futura. |
| `captured_at` | `timestamptz` | Sim | Momento em que a disponibilidade foi registrada. |
| `created_at` | `timestamptz` | Sim | Data de criacao do registro. |

Chave primaria: `id`.

Chaves estrangeiras: `establishment_id` referencia `establishments.id`.

Campos obrigatorios: `id`, `establishment_id`, `total_sets`, `available_sets`, `captured_at`, `created_at`.

Status possiveis: nao usa `status`.

Observacoes de negocio:

- Esta tabela registra disponibilidade agregada, nao conjuntos individuais.
- QR Code, codigo manual e identificacao fisica de cada conjunto ficam fora desta proposta inicial.
- Para exibir o estado atual, o app deve considerar o snapshot mais recente de cada estabelecimento.

### `reviews_summary`

Finalidade: guardar agregacoes futuras de avaliacoes sem implementar avaliacoes completas nesta fase.

| Campo | Tipo sugerido | Obrigatorio | Observacao |
| --- | --- | --- | --- |
| `id` | `uuid` | Sim | Chave primaria. |
| `establishment_id` | `uuid` | Sim | Referencia `establishments.id`. |
| `average_rating` | `numeric` | Sim | Media agregada. |
| `reviews_count` | `integer` | Sim | Quantidade total agregada. |
| `last_review_at` | `timestamptz` | Nao | Data da avaliacao mais recente. |
| `created_at` | `timestamptz` | Sim | Data de criacao. |
| `updated_at` | `timestamptz` | Sim | Data da ultima alteracao. |

Chave primaria: `id`.

Chaves estrangeiras: `establishment_id` referencia `establishments.id`.

Campos obrigatorios: `id`, `establishment_id`, `average_rating`, `reviews_count`, `created_at`, `updated_at`.

Status possiveis: nao usa `status`.

Observacoes de negocio:

- Esta tabela e apenas uma agregacao futura.
- Avaliacoes completas, bilaterais, comentarios e moderacao nao entram neste schema inicial.
- A existencia desta tabela deve ser reavaliada quando a fase real de avaliacoes for aprovada.

## Fase B - Autenticacao, perfis e cadastro de estabelecimentos

### `profiles`

Finalidade: representar usuarios autenticados da plataforma.

| Campo | Tipo sugerido | Obrigatorio | Observacao |
| --- | --- | --- | --- |
| `id` | `uuid` | Sim | Chave primaria interna do profile. |
| `auth_user_id` | `uuid` | Sim | Referencia futura a `auth.users.id` do Supabase Auth. |
| `full_name` | `text` | Nao | Nome do usuario. |
| `email` | `text` | Nao | Email principal, se permitido. |
| `phone` | `text` | Nao | Telefone, se permitido. |
| `avatar_url` | `text` | Nao | Foto de perfil. |
| `status` | `text` | Sim | `active`, `inactive` ou `blocked`. |
| `created_at` | `timestamptz` | Sim | Data de criacao. |
| `updated_at` | `timestamptz` | Sim | Data da ultima alteracao. |
| `deleted_at` | `timestamptz` | Nao | Remocao logica, se necessaria. |

Chave primaria: `id`.

Chaves estrangeiras: `auth_user_id` referencia futura a `auth.users.id`.

Campos obrigatorios: `id`, `auth_user_id`, `status`, `created_at`, `updated_at`.

Status possiveis: `active`, `inactive`, `blocked`.

Observacoes de negocio:

- Visitantes sem login nao precisam de registro em `profiles`.
- Dados pessoais exigem cuidado com LGPD.
- O papel do usuario deve ficar separado em `profile_roles`, evitando limitar o usuario a apenas um papel.

### `profile_roles`

Finalidade: vincular um ou mais papeis a um profile.

Justificativa: um mesmo usuario pode ser consumidor e tambem dono de estabelecimento. Em vez de manter apenas um campo `role` em `profiles`, esta tabela permite multiplos papeis com mais flexibilidade.

| Campo | Tipo sugerido | Obrigatorio | Observacao |
| --- | --- | --- | --- |
| `id` | `uuid` | Sim | Chave primaria. |
| `profile_id` | `uuid` | Sim | Referencia `profiles.id`. |
| `role` | `text` | Sim | `customer`, `establishment_owner`, `establishment_staff` ou `platform_admin`. |
| `created_at` | `timestamptz` | Sim | Data de criacao. |
| `updated_at` | `timestamptz` | Sim | Data da ultima alteracao. |
| `deleted_at` | `timestamptz` | Nao | Remocao logica. |

Chave primaria: `id`.

Chaves estrangeiras: `profile_id` referencia `profiles.id`.

Campos obrigatorios: `id`, `profile_id`, `role`, `created_at`, `updated_at`.

Status possiveis: nao usa `status`; usa `role`.

Observacoes de negocio:

- `platform_admin` deve ser concedido apenas por outro administrador ou por processo manual seguro.
- RLS deve impedir que usuarios alterem seus proprios papeis livremente.

### `establishment_signup_requests`

Finalidade: registrar solicitacoes de cadastro de novos estabelecimentos.

| Campo | Tipo sugerido | Obrigatorio | Observacao |
| --- | --- | --- | --- |
| `id` | `uuid` | Sim | Chave primaria. |
| `beach_id` | `uuid` | Nao | Referencia `beaches.id`, se a praia for selecionada. |
| `requester_profile_id` | `uuid` | Nao | Referencia `profiles.id`, se usuario estiver logado. |
| `requester_name` | `text` | Sim | Nome de quem solicitou. |
| `requester_phone` | `text` | Nao | Telefone de contato. |
| `requester_email` | `text` | Nao | Email de contato. |
| `establishment_name` | `text` | Sim | Nome informado do estabelecimento. |
| `operation_type` | `text` | Nao | Tipo sugerido de operacao. |
| `address` | `text` | Nao | Endereco ou ponto de referencia. |
| `message` | `text` | Nao | Observacoes da solicitacao. |
| `status` | `text` | Sim | `pending`, `approved` ou `rejected`. |
| `reviewed_by_profile_id` | `uuid` | Nao | Admin que analisou. |
| `reviewed_at` | `timestamptz` | Nao | Data da analise. |
| `rejection_reason` | `text` | Nao | Motivo de recusa, se houver. |
| `created_establishment_id` | `uuid` | Nao | Estabelecimento criado apos aprovacao. |
| `created_at` | `timestamptz` | Sim | Data de criacao. |
| `updated_at` | `timestamptz` | Sim | Data da ultima alteracao. |

Chave primaria: `id`.

Chaves estrangeiras:

- `beach_id` referencia `beaches.id`.
- `requester_profile_id` referencia `profiles.id`.
- `reviewed_by_profile_id` referencia `profiles.id`.
- `created_establishment_id` referencia `establishments.id`.

Campos obrigatorios: `id`, `requester_name`, `establishment_name`, `status`, `created_at`, `updated_at`.

Status possiveis: `pending`, `approved`, `rejected`.

Observacoes de negocio:

- A aprovacao deve ser feita por `platform_admin`.
- A aprovacao pode criar um registro em `establishments` com `status = approved`, se esse fluxo for escolhido.
- Antes de executar SQL, decidir quem pode criar estabelecimento: admin, bar ou ambos.

### `establishment_members`

Finalidade: vincular perfis autenticados a estabelecimentos e preparar permissoes futuras.

| Campo | Tipo sugerido | Obrigatorio | Observacao |
| --- | --- | --- | --- |
| `id` | `uuid` | Sim | Chave primaria. |
| `establishment_id` | `uuid` | Sim | Referencia `establishments.id`. |
| `profile_id` | `uuid` | Sim | Referencia `profiles.id`. |
| `role` | `text` | Sim | `establishment_owner` ou `establishment_staff`. |
| `status` | `text` | Sim | `pending`, `active`, `inactive` ou `revoked`. |
| `permissions` | `jsonb` | Nao | Permissoes especificas futuras. |
| `invited_by_profile_id` | `uuid` | Nao | Quem convidou. |
| `invited_at` | `timestamptz` | Nao | Data do convite. |
| `accepted_at` | `timestamptz` | Nao | Data de aceite. |
| `created_at` | `timestamptz` | Sim | Data de criacao. |
| `updated_at` | `timestamptz` | Sim | Data da ultima alteracao. |
| `deleted_at` | `timestamptz` | Nao | Remocao logica. |

Chave primaria: `id`.

Chaves estrangeiras:

- `establishment_id` referencia `establishments.id`.
- `profile_id` referencia `profiles.id`.
- `invited_by_profile_id` referencia `profiles.id`.

Campos obrigatorios: `id`, `establishment_id`, `profile_id`, `role`, `status`, `created_at`, `updated_at`.

Status possiveis: `pending`, `active`, `inactive`, `revoked`.

Observacoes de negocio:

- Donos e equipe devem editar apenas dados do proprio estabelecimento, futuramente.
- Um usuario pode estar vinculado a mais de um estabelecimento, se a regra de negocio permitir.
- Permissoes detalhadas devem ser simples no inicio e evoluir apenas quando houver necessidade real.

### `audit_logs`

Finalidade: registrar acoes relevantes para auditoria, suporte e seguranca.

| Campo | Tipo sugerido | Obrigatorio | Observacao |
| --- | --- | --- | --- |
| `id` | `uuid` | Sim | Chave primaria. |
| `actor_profile_id` | `uuid` | Nao | Perfil que executou a acao. |
| `establishment_id` | `uuid` | Nao | Estabelecimento relacionado, se houver. |
| `action` | `text` | Sim | Nome da acao executada. |
| `entity_type` | `text` | Sim | Nome da tabela ou entidade afetada. |
| `entity_id` | `uuid` | Nao | ID do registro afetado. |
| `status` | `text` | Nao | `success` ou `failed`. |
| `metadata` | `jsonb` | Nao | Dados extras sem informacao sensivel desnecessaria. |
| `ip_address` | `text` | Nao | IP, se coletado de forma permitida. |
| `user_agent` | `text` | Nao | Navegador/dispositivo, se aplicavel. |
| `created_at` | `timestamptz` | Sim | Data do evento. |

Chave primaria: `id`.

Chaves estrangeiras:

- `actor_profile_id` referencia `profiles.id`.
- `establishment_id` referencia `establishments.id`.

Campos obrigatorios: `id`, `action`, `entity_type`, `created_at`.

Status possiveis: `success`, `failed`.

Observacoes de negocio:

- Acoes administrativas, aprovacoes, recusas, alteracoes de permissao e alteracoes sensiveis devem ser auditadas.
- Evitar guardar dados pessoais ou segredos dentro de `metadata`.
- Logs de auditoria devem ter politicas de leitura bem restritas.

## Proposta conceitual de Row Level Security

Esta secao descreve a ideia de acesso futuro. Ela nao e SQL e nao deve ser executada ainda.

- Visitantes podem ler praias ativas.
- Visitantes podem ler estabelecimentos aprovados, ativos publicamente e vinculados a praias ativas.
- Visitantes podem ler fotos, categorias, itens de cardapio e disponibilidade publica de estabelecimentos aprovados.
- Visitantes podem ler apenas itens de cardapio publicos de estabelecimentos ativos/aprovados.
- Usuarios autenticados podem ler e atualizar campos permitidos do proprio `profile`.
- Usuarios autenticados nao podem alterar seus proprios papeis em `profile_roles`.
- Donos e equipe de estabelecimento podem editar apenas dados do proprio estabelecimento, futuramente.
- Donos e equipe nao devem aprovar o proprio estabelecimento sem administracao da plataforma.
- `platform_admin` pode aprovar e reprovar solicitacoes de cadastro.
- `platform_admin` pode gerenciar dados mestres, como praias, estabelecimentos, categorias e regras publicas.
- `audit_logs` devem ser lidos apenas por `platform_admin` ou processos internos autorizados.

## O que nao entra neste schema inicial

As entidades abaixo ficam fora desta proposta inicial e exigem ciclos especificos de produto, seguranca e implementacao:

- `orders`;
- `order_items`;
- `tabs`;
- pagamentos;
- cashback real;
- reservas;
- QR Codes;
- ambulantes;
- split de pagamentos;
- avaliacoes completas bilaterais;
- carteira interna;
- integracoes externas;
- backend operacional de pedidos;
- historico financeiro;
- painel completo do estabelecimento.

## Perguntas pendentes antes de executar SQL

- Supabase sera criado em qual conta?
- O app usara login por e-mail/senha, Google, Apple ou telefone?
- O estabelecimento tera login proprio ja na primeira fase real?
- Quem podera criar estabelecimento: admin, bar ou ambos?
- As fotos ficarao no Supabase Storage desde o inicio?
- Quais dados serao publicos no PWA?
- Quais dados precisam de aprovacao administrativa antes de aparecer?
- Quais campos pessoais devem ser evitados ou minimizados por LGPD?
- A disponibilidade de conjuntos sera informada manualmente ou calculada futuramente?
- O cadastro de estabelecimento aprovado deve criar automaticamente um usuario dono?

## Proximo passo sugerido

Criar `SUPABASE_SETUP_GUIDE.md` com um passo a passo manual para criar o projeto Supabase, ainda sem conectar o Flutter e sem implementar backend real.
