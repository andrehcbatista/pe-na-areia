# Pe na Areia - Revisao de prontidao para execucao futura no Supabase

## 1. Aviso inicial

Este documento e uma revisao de prontidao.

- Nenhum SQL foi executado.
- Nenhuma tabela foi criada.
- O MVP 1 continua mockado.
- A execucao no Supabase so deve ocorrer apos aprovacao humana.
- Este documento nao implementa Supabase, backend, login, pagamento, pedido, comanda, reserva, cashback real, QR Code real, Google Maps real ou integracoes externas.

## 2. Arquivos revisados

- `supabase/schema_phase_ab_draft.sql`
- `supabase/rls_phase_ab_draft.sql`
- `supabase/seed_phase_a_draft.sql`

## 3. Checklist de consistencia do schema

- [x] Tabelas esperadas para as fases A e B existem no draft principal:
  `profiles`, `beaches`, `establishments`, `establishment_photos`,
  `menu_categories`, `menu_items`, `establishment_availability_snapshots`,
  `establishment_signup_requests`, `establishment_members` e `audit_logs`.
- [x] Enums esperados existem:
  `beach_status`, `establishment_status`, `signup_request_status`,
  `profile_role`, `operation_type` e `menu_item_status`.
- [x] Chaves primarias usam UUID com `gen_random_uuid()`.
- [x] Foreign keys parecem coerentes com o modelo das fases A e B.
- [x] Timestamps existem nas tabelas. Tabelas editaveis usam `created_at` e
  `updated_at`; snapshots e logs usam campos de criacao/captura adequados ao
  uso proposto.
- [x] Campos chamados `status` usam enums no schema draft.
- [x] Nomes de tabelas, campos, constraints e indices estao em `snake_case`.
- [x] Nao foram encontrados valores de chaves, senhas, tokens, URLs reais ou
  dados sensiveis. Existem apenas nomes de colunas como `cover_image_url`,
  `logo_url`, `avatar_url` e `image_url`, sem valores reais preenchidos.

## 4. Checklist de consistencia da RLS

- [x] RLS e habilitada para todas as tabelas do schema draft.
- [~] As policies sao majoritariamente conservadoras, mas ha pontos para
  revisao manual antes de execucao, especialmente policies `for all` em dados
  operacionais do estabelecimento e o helper amplo `can_manage_establishment`.
- [x] Leitura publica esta restrita a praias ativas, estabelecimentos aprovados
  e ativos, categorias/fotos/itens ativos e disponibilidade de estabelecimentos
  aprovados e ativos.
- [x] Dados de `profiles` estao protegidos contra leitura publica.
- [~] Dados administrativos nao sao publicos por RLS, mas revisar manualmente
  se a leitura publica direta de `establishments` deve expor todos os campos da
  tabela ou se o futuro app deve usar views/RPCs publicas com colunas limitadas.
- [x] `establishment_members` e usado como base para permissoes de
  estabelecimento.
- [x] `service_role` e mencionado apenas como chave que nunca deve ir para o
  Flutter ou cliente. Nao e tratado como chave de app.

## 5. Checklist de consistencia dos seeds

- [x] Seeds declaram uso de dados ficticios e de teste.
- [x] Seeds nao usam nomes reais de estabelecimentos.
- [x] Seed de Boa Viagem esta claro e identificado como praia piloto.
- [x] Categorias e produtos estao coerentes com o MVP 1 publico.
- [x] Seeds referenciam tabelas e campos existentes no schema draft.
- [x] Seeds nao contem dados pessoais reais; telefones, imagens e logos ficam
  nulos.
- [x] Seeds nao contem chaves, senhas, tokens, URLs reais ou segredos.
- [~] Revisar manualmente o uso de marcas reais em produtos, como refrigerantes
  e cervejas, antes de qualquer uso fora de teste interno.

## 6. Problemas ou pontos de atencao encontrados

1. `DATABASE_SCHEMA_V1.md` menciona a possibilidade de `profile_roles`, mas o
   schema draft usa `profiles.role` diretamente. Isso nao impede a revisao
   humana, mas a decisao deve ser confirmada antes de execucao real.

2. A RLS usa `can_manage_establishment()` para varios tipos de gestao. Esse
   helper aceita dono do estabelecimento e permissoes futuras como
   `manage_establishment`, `manage_menu` e `manage_availability`. Revisar
   manualmente se esse helper esta amplo demais para fotos, categorias, itens e
   disponibilidade.

3. Algumas policies usam `for all` em tabelas como `establishment_photos`,
   `menu_categories` e `menu_items`. Elas estao restritas a membros autorizados,
   mas devem ser revisadas para confirmar se insert, update e delete devem ter
   regras separadas.

4. A policy de update em `establishments` reconhece em comentario que RLS nao
   limita colunas alteradas. Revisar manualmente protecao de campos sensiveis
   como `status`, `beach_id`, `slug` e dados de aprovacao.

5. A policy de update em `profiles` tambem reconhece que RLS nao limita colunas
   alteradas. Revisar manualmente protecao de `role`, `is_active`,
   `auth_user_id` e campos sensiveis antes de permitir edicao real.

6. A leitura publica de `establishments` retorna a linha inteira permitida pela
   policy. Revisar manualmente se todos os campos dessa tabela sao realmente
   publicos ou se sera melhor criar uma view publica com campos limitados.

7. A leitura publica de `establishment_availability_snapshots` permite ler
   snapshots ativos de estabelecimentos aprovados. Revisar manualmente se o app
   deve ler todos os snapshots ativos ou apenas o mais recente por
   estabelecimento via consulta, view ou RPC.

8. Os seeds incluem coordenadas aproximadas de Boa Viagem e dos estabelecimentos
   ficticios. O proprio arquivo informa que coordenadas devem ser validadas
   antes de qualquer uso de producao. Revisar manualmente.

9. Os seeds incluem marcas reais de produtos. Elas nao sao dados pessoais nem
   nomes reais de estabelecimentos, mas devem ser revisadas manualmente para
   decidir se ficam no seed aprovado ou se devem ser substituidas por nomes
   genericos.

10. Nao foi feita validacao executando SQL, por regra deste ciclo. Portanto,
    compatibilidade sintatica final, ordem de execucao e comportamento real das
    policies devem ser revisados no Supabase apenas em execucao manual
    supervisionada e aprovada.

## 7. Decisao de prontidao

Classificacao: **Pronto para revisao humana**.

Justificativa: os drafts estao separados por responsabilidade, nao contem
segredos, nao alteram o MVP mockado e apresentam schema, RLS e seeds coerentes
com as fases A e B. Ha pontos importantes para revisao humana antes de qualquer
execucao, especialmente granularidade de RLS, protecao de colunas sensiveis,
decisao sobre multiplos papeis e validacao dos seeds. Portanto, o material esta
pronto para ser revisado por uma pessoa, mas ainda nao deve ser tratado como
aprovado para execucao automatica ou producao.

## 8. Ordem recomendada de execucao futura, se aprovado

1. Executar `schema_phase_ab_draft.sql`.
2. Executar `rls_phase_ab_draft.sql`.
3. Executar `seed_phase_a_draft.sql`.
4. Testar leitura publica.
5. Testar acesso autenticado.
6. So depois iniciar integracao Flutter em ciclo separado.

## 9. Checklist manual antes de colar SQL no Supabase

- [ ] Confirmar que esta no projeto Supabase correto.
- [ ] Confirmar que o SQL Editor esta no ambiente correto.
- [ ] Copiar apenas o script aprovado.
- [ ] Executar primeiro o schema.
- [ ] Verificar erros.
- [ ] Executar RLS somente se schema passar.
- [ ] Executar seeds somente se RLS e schema passarem.
- [ ] Nunca colar `service_role key` no app.
- [ ] Registrar qualquer erro antes de tentar corrigir.

## 10. Proximo passo sugerido

Se a revisao humana apontar problemas, criar um ciclo separado de ajuste dos
drafts SQL, sem execucao real.

Se a revisao humana aprovar os drafts, fazer execucao manual supervisionada no
Supabase, seguindo a ordem recomendada e registrando qualquer erro antes de
tentar corrigir.
