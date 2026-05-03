# Pe na Areia - Plano conceitual de Row Level Security

## Aviso inicial

Este documento e conceitual.

Nenhuma policy foi criada. Nenhum SQL deve ser executado ainda. O app continua mockado no MVP 1, sem backend real, sem Supabase implementado e sem alteracao no codigo Flutter.

A Row Level Security real sera implementada apenas em um ciclo futuro aprovado, depois de revisao tecnica, revisao de produto e validacao das tabelas definitivas.

## Objetivo da RLS

A Row Level Security futura deve proteger o banco de dados do Pe na Areia, garantindo que cada perfil acesse apenas os dados permitidos.

Os objetivos principais sao:

- proteger dados de usuarios;
- separar permissoes por perfil;
- permitir leitura publica apenas de dados aprovados;
- impedir que estabelecimentos acessem dados de outros estabelecimentos;
- permitir administracao pela plataforma;
- preparar o produto para LGPD e operacao real.

## Perfis futuros

### visitor

Visitante nao autenticado. Pode consultar somente dados publicos aprovados, como praias ativas, estabelecimentos aprovados e ativos, cardapios publicos e disponibilidade publica.

### customer

Consumidor logado. Podera consultar dados publicos e gerenciar apenas seus proprios dados pessoais no `profiles`. Funcionalidades futuras como pedidos, comandas, cashback, reservas e avaliacoes exigirao politicas proprias em ciclos especificos.

### establishment_owner

Dono ou responsavel principal por um estabelecimento. Podera gerenciar dados do proprio estabelecimento, cardapio, fotos, disponibilidade e equipe, conforme permissoes aprovadas.

### establishment_staff

Equipe autorizada de um estabelecimento. Podera acessar e editar apenas areas permitidas do proprio estabelecimento, como cardapio e disponibilidade, quando essa permissao existir.

### platform_admin

Administrador da plataforma. Podera aprovar ou reprovar solicitacoes, gerenciar dados mestres, moderar conteudos e acessar informacoes necessarias para suporte, seguranca e auditoria.

## Matriz resumida de permissoes por perfil

| Perfil | Pode ler | Pode criar | Pode editar | Nao pode fazer |
| --- | --- | --- | --- | --- |
| `visitor` | Praias ativas, estabelecimentos aprovados e ativos, fotos ativas, cardapios publicos e disponibilidade publica. | Solicitar cadastro de estabelecimento, se o fluxo publico for aprovado. | Nada. | Ver dados pessoais, dados administrativos, solicitacoes internas, membros ou logs. |
| `customer` | Dados publicos e o proprio `profile`. | O proprio `profile`, se o fluxo de autenticacao permitir. Solicitar cadastro de estabelecimento, se aprovado. | Campos permitidos do proprio `profile`. | Alterar o proprio papel, acessar dados de outros usuarios, aprovar estabelecimentos ou editar dados de bares. |
| `establishment_owner` | Dados publicos, proprio `profile`, dados do proprio estabelecimento e membros vinculados ao proprio estabelecimento. | Dados operacionais do proprio estabelecimento, conforme fase aprovada. | Dados do proprio estabelecimento, cardapio, fotos, disponibilidade e membros autorizados. | Acessar outro estabelecimento, aprovar a propria solicitacao, alterar permissoes de plataforma ou ver dados administrativos globais. |
| `establishment_staff` | Dados publicos, proprio `profile` e dados autorizados do proprio estabelecimento. | Registros operacionais permitidos pelo dono ou pela plataforma. | Cardapio e disponibilidade, se autorizado. | Acessar outro estabelecimento, alterar dono, aprovar solicitacoes, ver auditoria ampla ou mudar permissoes sensiveis. |
| `platform_admin` | Dados publicos, dados administrativos, solicitacoes, membros e logs necessarios para operacao. | Praias, estabelecimentos, registros administrativos e logs via processos seguros. | Aprovar/reprovar solicitacoes, moderar dados e gerenciar cadastros. | Usar dados fora da finalidade do produto ou expor informacoes pessoais sem necessidade. |

## Regras conceituais por tabela

### `beaches`

Leitura publica: visitantes podem ler apenas praias ativas.

Leitura autenticada: usuarios autenticados tambem podem ler praias ativas. Administradores podem ler praias ativas e inativas.

Criacao: apenas `platform_admin` deve criar novas praias.

Edicao: apenas `platform_admin` deve editar praias, status e dados de localizacao.

Exclusao: evitar exclusao fisica. Preferir inativacao ou remocao logica, feita apenas por `platform_admin`.

Observacoes de seguranca: praias inativas nao devem aparecer no app publico. A ativacao de novas praias deve ser controlada pela plataforma.

### `establishments`

Leitura publica: visitantes podem ler apenas estabelecimentos aprovados, ativos e vinculados a praias ativas.

Leitura autenticada: consumidores logados podem ler os mesmos dados publicos. Donos e equipe podem ler dados do proprio estabelecimento. Administradores podem ler todos os estabelecimentos.

Criacao: em fluxo futuro, solicitacoes devem nascer em `establishment_signup_requests`. A criacao direta de estabelecimento aprovado deve ser feita apenas por `platform_admin` ou processo interno seguro.

Edicao: donos e equipe autorizada podem editar apenas dados do proprio estabelecimento, quando o estabelecimento estiver aprovado e ativo. Campos sensiveis, como status de aprovacao, devem ficar restritos a `platform_admin`.

Exclusao: evitar exclusao fisica. Preferir status `inactive`, `suspended` ou remocao logica por `platform_admin`.

Observacoes de seguranca: estabelecimento nao pode acessar nem editar dados de outro estabelecimento. Dados administrativos nao devem aparecer no PWA publico.

### `establishment_photos`

Leitura publica: visitantes podem ler fotos ativas de estabelecimentos aprovados e ativos.

Leitura autenticada: usuarios autenticados podem ler fotos publicas. Donos e equipe podem ler fotos do proprio estabelecimento, inclusive em revisao ou inativas, se autorizado. Administradores podem ler todas.

Criacao: donos e equipe autorizada podem criar fotos apenas para o proprio estabelecimento. Administradores podem criar fotos para qualquer estabelecimento.

Edicao: donos e equipe autorizada podem editar ordem, texto alternativo e status de fotos do proprio estabelecimento. Administradores podem moderar qualquer foto.

Exclusao: preferir inativacao ou remocao logica. Exclusao fisica deve ser restrita e revisada, principalmente se houver Supabase Storage.

Observacoes de seguranca: URLs de Storage devem respeitar politicas proprias. Fotos inativas ou rejeitadas nao devem aparecer publicamente.

### `menu_categories`

Leitura publica: visitantes podem ler categorias ativas de estabelecimentos aprovados e ativos.

Leitura autenticada: usuarios autenticados podem ler categorias publicas. Donos e equipe podem ler categorias do proprio estabelecimento, inclusive inativas, se autorizado. Administradores podem ler todas.

Criacao: donos e equipe autorizada podem criar categorias apenas para o proprio estabelecimento. Administradores podem criar para qualquer estabelecimento.

Edicao: donos e equipe autorizada podem editar categorias do proprio estabelecimento. Administradores podem editar qualquer categoria.

Exclusao: preferir inativacao ou remocao logica para preservar historico.

Observacoes de seguranca: categorias inativas nao devem aparecer no cardapio publico.

### `menu_items`

Leitura publica: visitantes podem ler itens ativos ou disponiveis de categorias ativas, vinculados a estabelecimentos aprovados e ativos.

Leitura autenticada: usuarios autenticados podem ler itens publicos. Donos e equipe podem ler todos os itens do proprio estabelecimento, inclusive indisponiveis ou inativos, se autorizado. Administradores podem ler todos.

Criacao: donos e equipe autorizada podem criar itens apenas para o proprio estabelecimento e dentro de categorias do proprio estabelecimento. Administradores podem criar para qualquer estabelecimento.

Edicao: donos e equipe autorizada podem editar preco, descricao, imagem, ordem e disponibilidade dos itens do proprio estabelecimento. Administradores podem editar ou moderar qualquer item.

Exclusao: preferir inativacao ou remocao logica. Exclusao fisica deve ser evitada porque pedidos futuros podem depender de historico de itens e precos.

Observacoes de seguranca: cashback real nao deve ser controlado por texto livre de cardapio. Quando houver pedidos, historico de preco deve ser protegido por snapshots.

### `establishment_availability_snapshots`

Leitura publica: visitantes podem ler a disponibilidade publica mais recente de estabelecimentos aprovados e ativos.

Leitura autenticada: usuarios autenticados podem ler a disponibilidade publica. Donos e equipe podem ler historico do proprio estabelecimento, se aprovado. Administradores podem ler todos os snapshots.

Criacao: donos e equipe autorizada podem criar snapshots apenas para o proprio estabelecimento. Administradores podem criar para qualquer estabelecimento.

Edicao: em regra, snapshots devem ser imutaveis. Se houver correcao, ela deve ser feita por novo snapshot ou por administrador com auditoria.

Exclusao: evitar exclusao. Administradores podem ocultar registros incorretos se houver campo de controle futuro.

Observacoes de seguranca: esta tabela representa disponibilidade agregada, nao cada conjunto fisico. QR Code e codigo manual ficam fora desta fase.

### `profiles`

Leitura publica: nenhuma leitura publica de dados pessoais.

Leitura autenticada: cada usuario pode ler apenas seu proprio `profile`. Donos e equipe nao devem ler dados pessoais de outros usuarios por padrao. Administradores podem ler dados necessarios para suporte e operacao, com finalidade clara.

Criacao: o proprio usuario autenticado pode criar seu `profile`, ou um processo seguro pode criar automaticamente apos cadastro no Supabase Auth.

Edicao: cada usuario pode editar apenas campos permitidos do proprio `profile`, como nome, telefone ou avatar. O usuario nao deve conseguir alterar o proprio papel, status ou permissoes sensiveis.

Exclusao: exclusao fisica deve ser evitada. Prever futura inativacao, bloqueio, exclusao ou anonimizacao conforme LGPD.

Observacoes de seguranca: telefone, e-mail, documentos e dados de responsaveis devem ter acesso restrito. A `service_role key` nunca deve ser usada no app Flutter.

### `establishment_signup_requests`

Leitura publica: nenhuma leitura publica.

Leitura autenticada: o solicitante autenticado pode ler apenas as proprias solicitacoes, se esse fluxo for aprovado. Administradores podem ler todas. Donos e equipe nao devem ler solicitacoes de terceiros.

Criacao: visitantes ou usuarios autenticados podem criar solicitacoes, se o fluxo publico for aprovado. O status inicial deve ser `pending`.

Edicao: solicitantes podem editar apenas campos limitados enquanto a solicitacao estiver pendente, se essa regra for aprovada. Administradores podem aprovar, reprovar, registrar motivo e vincular estabelecimento criado.

Exclusao: evitar exclusao fisica. Administradores podem cancelar, arquivar ou marcar como rejeitada.

Observacoes de seguranca: esta tabela pode conter nome, telefone e e-mail de responsaveis. Esses dados nao devem aparecer no PWA publico.

### `establishment_members`

Leitura publica: nenhuma leitura publica.

Leitura autenticada: cada membro pode ler seu proprio vinculo. Donos podem ler membros do proprio estabelecimento. Administradores podem ler todos.

Criacao: donos autorizados podem convidar membros para o proprio estabelecimento, se essa regra for aprovada. Administradores podem criar vinculos. Um estabelecimento nao pode criar membro para outro estabelecimento.

Edicao: donos autorizados podem editar equipe do proprio estabelecimento, com restricoes. Equipe comum nao deve alterar o proprio papel nem permissoes. Administradores podem editar qualquer vinculo.

Exclusao: preferir revogacao ou inativacao do vinculo, mantendo historico.

Observacoes de seguranca: permissoes devem ser simples no inicio. Alteracoes de dono, equipe e permissao devem gerar auditoria.

### `audit_logs`

Leitura publica: nenhuma leitura publica.

Leitura autenticada: usuarios comuns nao devem ler logs. Donos podem eventualmente ver logs limitados do proprio estabelecimento, se houver necessidade aprovada. Administradores podem ler logs necessarios para suporte, seguranca e auditoria.

Criacao: logs devem ser criados por processos internos seguros, triggers, Edge Functions ou operacoes administrativas controladas.

Edicao: audit logs nao devem ser editaveis por usuarios comuns. Idealmente, logs devem ser imutaveis.

Exclusao: usuarios comuns nao devem excluir logs. Retencao, anonimizacao ou limpeza devem seguir politica administrativa e LGPD.

Observacoes de seguranca: nao gravar segredos, tokens, dados de cartao ou dados pessoais desnecessarios em `metadata`. Acoes sensiveis, como aprovacao de estabelecimento e mudanca de permissao, devem ser auditadas.

## Exemplos de regras esperadas

- Visitantes podem ler apenas praias ativas.
- Visitantes podem ler apenas estabelecimentos aprovados e ativos.
- Visitantes podem ler cardapios de estabelecimentos aprovados e ativos.
- Clientes autenticados podem ler e atualizar apenas seu proprio `profile`.
- Estabelecimentos podem editar apenas seus proprios dados, quando aprovados.
- Equipe do estabelecimento pode editar cardapio e disponibilidade, se autorizada.
- Administradores da plataforma podem aprovar ou reprovar solicitacoes.
- Audit logs nao devem ser editaveis por usuarios comuns.
- A `service_role key` nunca deve ser usada no app Flutter.

## Funcoes auxiliares futuras

As funcoes abaixo sao apenas sugestoes conceituais para simplificar policies futuras. Nenhum SQL deve ser criado agora.

### `is_platform_admin(user_id)`

Verificaria se o usuario autenticado tem permissao de administrador da plataforma.

Uso conceitual: permitir operacoes administrativas, leitura de logs e aprovacao de solicitacoes.

### `is_establishment_member(user_id, establishment_id)`

Verificaria se o usuario autenticado e membro ativo de um estabelecimento especifico.

Uso conceitual: permitir leitura de dados internos do proprio estabelecimento.

### `can_manage_establishment(user_id, establishment_id)`

Verificaria se o usuario pode gerenciar um estabelecimento especifico, considerando dono, equipe, status do vinculo e permissoes.

Uso conceitual: controlar edicao de dados do estabelecimento, cardapio, fotos e disponibilidade.

### `current_user_role()`

Retornaria o papel principal ou os papeis do usuario autenticado, conforme a modelagem final escolhida.

Uso conceitual: reduzir repeticao em policies e facilitar auditoria das regras.

## Cuidados LGPD

- Limitar exposicao de dados pessoais ao minimo necessario.
- Proteger telefone, e-mail e dados de responsaveis.
- Separar dados publicos de dados administrativos.
- Registrar auditoria de acoes sensiveis.
- Permitir futura exclusao, bloqueio ou anonimizacao de dados quando aplicavel.
- Evitar guardar informacoes pessoais em campos livres, como `metadata`, `message` ou comentarios.
- Exibir no PWA apenas dados realmente publicos e aprovados.

## Riscos

- Policy permissiva demais.
- Dados administrativos visiveis no PWA.
- Estabelecimento acessando dados de outro estabelecimento.
- Uso indevido da `service_role key`.
- Falta de auditoria em aprovacoes.
- Exposicao de dados pessoais em reviews ou solicitacoes.
- Usuario conseguindo alterar o proprio papel ou status.
- Fotos ou arquivos de Storage publicos sem revisao de permissao.
- Logs contendo dados pessoais ou segredos sem necessidade.

## Proximo passo sugerido

Criar `SUPABASE_SEED_PLAN.md` com um plano de dados iniciais para Boa Viagem e estabelecimentos mockados, ainda sem executar SQL.
