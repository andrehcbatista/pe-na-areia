# Pe na Areia - Registro de execucao manual inicial do Supabase

## 1. Aviso inicial

Este arquivo registra a execucao manual inicial de scripts SQL no projeto Supabase do Pe na Areia.

- Este documento nao deve conter chaves, URLs, senhas, tokens ou dados sensiveis.
- O app Flutter ainda nao esta conectado ao Supabase.
- O MVP 1 visual ainda usa dados mockados locais ate um ciclo especifico de integracao.
- Este registro documenta resultados informados pelo usuario apos execucao manual no Supabase SQL Editor.

## 2. Scripts executados

Os scripts iniciais executados manualmente foram:

1. `supabase/schema_phase_ab_draft.sql`
2. `supabase/rls_phase_ab_draft.sql`
3. `supabase/seed_phase_a_draft.sql`

## 3. Ordem de execucao

A ordem seguida foi:

1. Schema
2. RLS
3. Seeds

## 4. Resultado da execucao

| Etapa | Script | Resultado informado |
| --- | --- | --- |
| Schema | `supabase/schema_phase_ab_draft.sql` | Sucesso |
| RLS | `supabase/rls_phase_ab_draft.sql` | Sucesso |
| Seeds | `supabase/seed_phase_a_draft.sql` | Sucesso |

## 5. Validacoes manuais feitas

As seguintes validacoes manuais foram informadas pelo usuario:

- A tabela `beaches` contem Boa Viagem.
- A tabela `establishments` contem os bares ficticios.
- A tabela `menu_items` contem produtos.

## 6. Estado atual apos execucao

- O banco Supabase foi criado.
- As tabelas iniciais existem.
- As RLS/policies iniciais foram aplicadas.
- Os seeds ficticios foram inseridos.
- O Flutter ainda nao foi integrado ao Supabase.
- Os dados mockados locais ainda permanecem no app.

## 7. Proximos passos recomendados

- Criar um ciclo especifico para preparar a camada de configuracao do Supabase no Flutter.
- Instalar o pacote Supabase Flutter apenas em ciclo proprio.
- Carregar variaveis de ambiente de forma segura.
- Criar camada de servico/repositorio para acesso aos dados.
- Testar leitura publica de praias e estabelecimentos.
- So depois substituir progressivamente dados mockados da Home e do cardapio por dados reais.

## 8. Atencoes

- Nao expor a `service_role key`.
- Nao publicar `.env.local`.
- Nao inserir dados reais de bares sem autorizacao.
- Revisar RLS antes de qualquer uso com dados sensiveis.
- Manter commits pequenos por ciclo.

