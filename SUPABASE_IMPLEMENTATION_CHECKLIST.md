# Pe na Areia - Checklist operacional para implementacao futura do Supabase

## Aviso inicial

Este checklist deve ser concluido antes de qualquer implementacao real no Supabase.

- Nao executar SQL sem revisao final.
- Nao conectar Flutter ao Supabase sem ciclo aprovado.
- Nao publicar chaves sensiveis no GitHub.
- O MVP 1 ainda permanece mockado ate integracao especifica.

## Documentos existentes e funcao de cada um

### `PROJECT_STATUS.md`

Registra o estado atual do projeto, confirma que o MVP 1 esta mockado e lista funcionalidades existentes, ausentes e proximos ciclos sugeridos.

### `TECH_DECISIONS.md`

Registra a decisao tecnica de usar Supabase como backend futuro, com justificativa, arquitetura sugerida e aviso de que a integracao ainda nao esta autorizada.

### `DATA_MODEL.md`

Descreve a modelagem conceitual inicial, perfis futuros, entidades principais, relacoes e riscos de produto, seguranca e LGPD.

### `DATABASE_SCHEMA_V1.md`

Define a proposta inicial de schema para as fases A e B, incluindo tabelas publicas do MVP 1 real, autenticacao futura, perfis e solicitacoes de cadastro.

### `SUPABASE_SETUP_GUIDE.md`

Orienta a criacao manual futura do projeto Supabase, com cuidados sobre conta, regiao, senha do banco, chaves, Auth, Storage e integracao com Flutter.

### `SUPABASE_SCHEMA_SQL_DRAFT.md`

Contem um rascunho tecnico de SQL para revisao futura. Nao e migration oficial e nao deve ser executado sem revisao tecnica, de produto e de seguranca.

### `SUPABASE_RLS_PLAN.md`

Documenta o plano conceitual de Row Level Security, perfis, matriz de permissoes, regras por tabela, riscos e cuidados de LGPD.

### `SUPABASE_SEED_PLAN.md`

Planeja dados ficticios iniciais para teste futuro do MVP 1 real, incluindo Boa Viagem, estabelecimentos demonstrativos, categorias, produtos e disponibilidade.

## Checklist antes de criar o projeto Supabase

- [ ] Definir qual conta sera dona do projeto.
- [ ] Definir e-mail de acesso.
- [ ] Definir se sera conta pessoal ou futura conta da empresa.
- [ ] Confirmar regiao do projeto.
- [ ] Definir padrao de nome: `pe-na-areia`.
- [ ] Escolher local seguro para guardar a senha do banco.
- [ ] Decidir quem tera acesso administrativo.

## Checklist antes de criar tabelas

- [ ] Revisar `DATABASE_SCHEMA_V1.md`.
- [ ] Revisar `SUPABASE_SCHEMA_SQL_DRAFT.md`.
- [ ] Validar nomes de tabelas.
- [ ] Validar enums.
- [ ] Validar campos publicos vs administrativos.
- [ ] Validar se `profiles` sera vinculado a `auth.users`.
- [ ] Validar se `signup_requests` e `establishments` terao fluxos separados.
- [ ] Validar se RLS sera criada antes de inserir dados sensiveis.

## Checklist antes de configurar Auth

- [ ] Decidir metodos de login iniciais:
  - [ ] e-mail/senha;
  - [ ] Google;
  - [ ] Apple;
  - [ ] telefone/OTP, se futuramente necessario.
- [ ] Decidir se consumidor e estabelecimento usarao o mesmo fluxo de login.
- [ ] Decidir como identificar `platform_admin`.
- [ ] Decidir como convidar `establishment_staff`.

## Checklist antes de configurar Storage

- [ ] Definir buckets:
  - [ ] `establishment-photos`;
  - [ ] `menu-item-photos`;
  - [ ] `profile-photos`.
- [ ] Definir politica de leitura publica/privada.
- [ ] Definir limite de tamanho de imagens.
- [ ] Definir quem pode enviar/alterar imagens.
- [ ] Decidir se imagens precisam de aprovacao antes de aparecer.

## Checklist antes de inserir seeds

- [ ] Usar apenas dados ficticios.
- [ ] Nao usar dados reais de bares sem autorizacao.
- [ ] Confirmar praia Boa Viagem.
- [ ] Confirmar textos e precos ficticios.
- [ ] Marcar claramente dados de demonstracao.

## Checklist de seguranca

- [ ] Nunca usar `service_role key` no Flutter.
- [ ] Nao salvar chaves secretas no GitHub.
- [ ] Ativar RLS antes de dados reais.
- [ ] Testar politicas por perfil.
- [ ] Separar dados publicos de administrativos.
- [ ] Proteger dados pessoais.
- [ ] Considerar LGPD.
- [ ] Registrar acoes sensiveis em `audit_logs`.

## Ordem segura de implementacao futura

1. Criar projeto Supabase.
2. Revisar schema SQL.
3. Criar tabelas base.
4. Criar enums/tipos.
5. Criar funcoes auxiliares de seguranca.
6. Ativar RLS.
7. Criar policies iniciais.
8. Inserir seeds ficticios.
9. Testar leitura publica no painel Supabase.
10. Criar integracao Flutter em ciclo separado.
11. Migrar Home/cardapio mockados para dados reais progressivamente.
12. Implementar Auth/perfis em ciclo proprio.

## Criterios para avancar para integracao Flutter

- [ ] Projeto Supabase criado.
- [ ] Tabelas revisadas.
- [ ] RLS planejada.
- [ ] Seeds ficticios inseridos.
- [ ] Leitura publica testada.
- [ ] `anon key` e URL disponiveis.
- [ ] `service_role key` protegida.
- [ ] Git limpo.
- [ ] Decisao clara sobre o proximo ciclo.

## Proximo passo sugerido

Criar o projeto Supabase manualmente seguindo `SUPABASE_SETUP_GUIDE.md`.

Nao conectar ao Flutter ainda.

Depois, registrar URL e `anon key` em arquivo local ignorado pelo Git, em ciclo proprio.
