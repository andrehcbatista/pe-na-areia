# Pe na Areia - Planejamento de autenticacao e perfis

## Aviso inicial

Este documento e apenas planejamento.

Nenhum login sera implementado neste ciclo.
Nenhuma tela sera alterada.
Nenhuma dependencia sera adicionada.
O app continuara publico e mockado nas areas ainda nao integradas.

Este plano nao autoriza implementacao de autenticacao, pedido, pagamento, comanda, reserva, cashback real, backend operacional, painel financeiro, QR Code real, ambulantes ou integracoes externas.

## Contexto atual

O projeto Pe na Areia ja possui:

- MVP 1 publico funcionando;
- Supabase criado;
- schema, RLS e seeds executados;
- Home, Detalhes e Cardapio lendo dados reais do Supabase com fallback;
- fluxo publico ainda preservado para consulta de estabelecimentos, cardapios, status, distancia e disponibilidade.

O projeto ainda nao possui:

- login;
- autenticacao real;
- perfis reais;
- pedido;
- pagamento;
- comanda;
- reserva.

## Objetivo da autenticacao futura

A autenticacao futura devera preparar o Pe na Areia para operacao real, permitindo:

- consumidor logado;
- estabelecimento gerenciar dados proprios;
- equipe do estabelecimento operar pedidos e comandas futuramente;
- administrador da plataforma aprovar cadastros e auditar dados;
- protecao de dados por perfil;
- base tecnica para LGPD, seguranca e governanca da operacao.

## Perfis futuros

Os perfis previstos sao:

- `visitor`;
- `customer`;
- `establishment_owner`;
- `establishment_staff`;
- `platform_admin`.

## Descricao dos perfis

### `visitor`

Usuario nao autenticado.

Pode ver praias, estabelecimentos aprovados, cardapios publicos e avaliacoes publicas, quando essas avaliacoes forem implementadas.

Nao pode pedir, pagar, reservar, avaliar ou abrir comanda.

### `customer`

Usuario consumidor logado.

Podera futuramente fazer pedido, abrir comanda, pagar, usar cashback, reservar e avaliar.

Deve ver apenas seus proprios dados privados.

### `establishment_owner`

Responsavel pelo estabelecimento.

Podera futuramente editar dados do bar, cardapio, fotos, conjuntos e campanhas.

Deve ver pedidos e comandas apenas do proprio estabelecimento.

### `establishment_staff`

Equipe operacional do estabelecimento.

Podera futuramente gerenciar pedidos, comandas, disponibilidade e atendimento.

Nao deve ter permissoes administrativas amplas.

### `platform_admin`

Administrador do Pe na Areia.

Podera aprovar ou reprovar estabelecimentos, gerenciar dados mestres, auditar acoes, supervisionar cadastros e acompanhar denuncias.

Esse perfil deve ser tratado com extrema cautela.

## Metodos de login recomendados para fases iniciais

Os metodos recomendados sao:

- e-mail e senha;
- Google;
- Apple futuramente para iOS;
- telefone/OTP apenas como avaliacao futura.

## Estrategia inicial recomendada

A estrategia recomendada e:

1. Comecar com e-mail e senha para desenvolvimento.
2. Adicionar Google depois.
3. Adicionar Apple antes da publicacao iOS, se login social for usado.
4. Nao comecar com telefone/OTP, para reduzir a complexidade inicial.

Telefone/OTP pode parecer simples para o usuario final, mas costuma exigir mais cuidado com custo, entrega de mensagens, abuso, validacao por pais, tentativas repetidas e suporte.

## Relacao com Supabase

O Supabase deve ser usado como base de autenticacao e autorizacao futura.

- `auth.users` sera a origem da autenticacao.
- `profiles` armazenara dados publicos ou operacionais do usuario.
- `profile_roles` ou um campo `role` em `profiles` definira o papel inicial, conforme a modelagem final aprovada.
- `establishment_members` vinculara usuarios autenticados a estabelecimentos.
- `platform_admin` deve ser controlado com extrema cautela.

Visitantes nao autenticados nao precisam ter registro em `profiles`.

O app Flutter nunca deve receber a `service_role key`.

## Fluxo inicial de cadastro de consumidor

Fluxo futuro sugerido:

1. Usuario informa nome, e-mail e senha.
2. Supabase Auth cria o usuario em `auth.users`.
3. App cria um registro em `profiles`.
4. O perfil recebe papel inicial `customer`.
5. Usuario passa a poder acessar area logada em fases futuras.

Esse fluxo nao deve bloquear a consulta publica do MVP 1.

## Fluxo inicial de estabelecimento

Fluxo futuro sugerido:

1. Bar envia solicitacao de cadastro.
2. Administrador da plataforma analisa a solicitacao.
3. Administrador aprova ou reprova.
4. Responsavel cria conta ou vincula uma conta existente.
5. `establishment_members` recebe vinculo como `establishment_owner`.
6. Painel do estabelecimento e liberado futuramente.

O estabelecimento nao deve aprovar o proprio cadastro.

## Fluxo inicial de administrador

Nao deve existir autocadastro como administrador.

O papel `platform_admin` deve ser definido manualmente no Supabase por um responsavel tecnico ou por processo administrativo seguro.

Quando aplicavel, a concessao ou alteracao desse perfil deve ser registrada em `audit_logs`.

## Telas futuras sugeridas

Telas que podem ser planejadas em ciclos futuros:

- Login;
- Cadastro de usuario;
- Recuperacao de senha;
- Perfil do consumidor;
- Area do estabelecimento;
- Area admin protegida;
- Tela de acesso negado.

Essas telas nao serao criadas neste ciclo.

## Regras de seguranca

As regras de seguranca recomendadas sao:

- nunca confiar apenas no frontend;
- permissoes devem ser reforcadas por RLS;
- `service_role` nunca deve ir para o Flutter;
- dados administrativos nao devem ser publicos;
- estabelecimento nao pode ver dados de outro estabelecimento;
- cliente nao pode ver dados privados de outro cliente;
- `platform_admin` deve ter acesso restrito e auditavel;
- usuarios nao devem conseguir alterar o proprio papel livremente;
- dados pessoais devem ser minimizados e tratados conforme LGPD;
- logs de auditoria nao devem armazenar chaves, tokens, senhas ou dados sensiveis desnecessarios.

## O que nao implementar ainda

Nao implementar neste ciclo:

- pedido;
- pagamento;
- comanda;
- reserva;
- QR Code real;
- cashback real;
- painel financeiro;
- ambulantes.

Tambem nao implementar login obrigatorio, painel real, backend operacional ou integracoes externas sem aprovacao expressa em um ciclo proprio.

## Proximos ciclos sugeridos

Proximos ciclos possiveis, sempre com escopo separado e aprovacao antes de implementar:

1. Criar `AUTH_IMPLEMENTATION_CHECKLIST.md`.
2. Preparar telas de login e cadastro sem ativar fluxo obrigatorio.
3. Integrar Supabase Auth.
4. Criar `profile` para `customer`.
5. Criar protecao de rotas.
6. Separar acesso de `visitor`, `customer`, `establishment_owner`, `establishment_staff` e `platform_admin`.

## Criterios antes de implementar login

Antes de qualquer implementacao real, revisar:

- metodo inicial de login;
- estrutura final de `profiles` e `profile_roles`;
- politicas RLS necessarias;
- fluxo de criacao de perfil;
- estrategia de recuperacao de senha;
- comportamento do app para visitante;
- telas que continuarao publicas;
- dados pessoais realmente necessarios;
- plano de testes por perfil.

## Decisao atual

Neste ciclo, a decisao e apenas documentar o planejamento.

O app permanece publico no MVP 1. Nenhuma tela, dependencia, SQL, RLS, Supabase ou codigo Flutter deve ser alterado por este documento.
