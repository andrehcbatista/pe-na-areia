# Pe na Areia - Guia manual de preparacao do Supabase

## Aviso inicial

Este guia e apenas preparatorio para uma criacao futura do projeto Supabase do Pe na Areia.

Neste ciclo:

- nao conectar o Flutter ao Supabase;
- nao instalar pacote Supabase no app;
- nao alterar `pubspec.yaml`;
- nao trocar dados mockados por dados reais;
- nao criar tabelas sem revisar previamente o schema;
- nao executar SQL sem revisao;
- nao expor chaves secretas publicamente.

O MVP 1 continua mockado ate existir um ciclo especifico e aprovado para integracao com backend.

## Pre-requisitos

Antes de criar o projeto Supabase, confirme se estes itens estao definidos:

- uma conta no Supabase;
- e-mail de acesso a essa conta;
- acesso ao repositorio GitHub do projeto Pe na Areia;
- entendimento de que este sera o backend futuro do Pe na Areia;
- decisao de qual conta sera dona do projeto Supabase.

A conta dona do projeto e importante porque ela tera controle administrativo sobre banco, chaves, configuracoes e cobranca futura, se houver.

## Passo a passo para criar o projeto Supabase

1. Acesse o site do Supabase.

   Entre em `https://supabase.com` pelo navegador.

2. Faca login na conta escolhida.

   Use o e-mail definido como responsavel pelo projeto.

3. Crie um novo projeto.

   No painel do Supabase, procure a opcao para criar um projeto novo.

4. Escolha a organizacao.

   Se houver mais de uma organizacao na conta, selecione a organizacao correta para o Pe na Areia.

5. Informe o nome do projeto.

   Nome sugerido:

   ```text
   pe-na-areia
   ```

6. Escolha a regiao.

   Se houver uma regiao proxima ao Brasil, escolha essa opcao preferencialmente.

   A regiao influencia a distancia entre os usuarios e o banco. Quanto mais perto, melhor tende a ser a resposta do sistema.

7. Defina uma senha forte para o banco.

   Use uma senha longa, dificil de adivinhar e unica para este projeto.

   Guarde essa senha em um local seguro. Nao envie por mensagem aberta e nao publique no GitHub.

8. Aguarde o provisionamento.

   O Supabase pode levar alguns minutos para preparar o projeto. Espere ate o painel indicar que o projeto esta pronto.

## Configuracoes iniciais recomendadas

Depois que o projeto estiver criado, localize as informacoes principais no painel do Supabase.

### Project URL

A `Project URL` e o endereco publico do projeto Supabase.

Ela sera usada futuramente pelo app ou por servicos autorizados, mas ainda nao deve ser conectada ao Flutter neste ciclo.

### anon public key

A `anon public key` e uma chave publica usada em cenarios controlados.

Ela podera ser usada futuramente pelo Flutter, desde que as regras de seguranca, especialmente RLS, estejam corretamente configuradas.

### service_role key

A `service_role key` e uma chave sensivel e poderosa.

Atencao:

- nunca cole a `service_role key` no Flutter;
- nunca publique a `service_role key` no GitHub;
- nunca envie essa chave em prints, mensagens abertas ou documentos publicos;
- use essa chave apenas em ambiente seguro e servidor autorizado, se isso for necessario em uma fase futura.

### Variaveis de ambiente futuras

As chaves e URLs deverao ser organizadas futuramente em variaveis de ambiente.

Isso ajuda a evitar que segredos fiquem escritos diretamente no codigo do aplicativo ou em arquivos publicos do repositorio.

## Configuracao de autenticacao futura

O Supabase Auth podera ser usado futuramente para autenticar consumidores, estabelecimentos e administradores.

As opcoes possiveis incluem:

- e-mail e senha;
- login com Google;
- login com Apple;
- telefone com OTP, se for avaliado depois.

A decisao exata sobre os metodos de login ainda nao foi tomada. Ela deve acontecer em um ciclo proprio de produto, seguranca e implementacao.

Neste ciclo, nao implementar login e nao conectar autenticacao ao Flutter.

## Configuracao de Storage futura

O Supabase Storage podera ser usado futuramente para armazenar imagens do Pe na Areia, como:

- fotos de estabelecimentos;
- fotos de produtos;
- imagens de cardapio;
- imagens de perfil, se necessario.

Buckets futuros sugeridos:

- `establishment-photos`;
- `menu-item-photos`;
- `profile-photos`.

As politicas de acesso desses buckets ainda precisam ser definidas. Nenhum bucket deve receber dados reais sem revisao das permissoes.

## Configuracao de banco futura

As tabelas futuras devem ser baseadas no documento `DATABASE_SCHEMA_V1.md`.

Esse documento descreve uma proposta inicial para as Fases A e B:

- Fase A: dados publicos reais do MVP 1;
- Fase B: autenticacao, perfis e solicitacoes de cadastro de estabelecimento.

Importante:

- nenhuma SQL deve ser executada sem revisao;
- nenhuma tabela deve ser criada sem confirmar o schema;
- nenhuma migration deve ser criada neste ciclo;
- RLS deve ser configurada antes de inserir ou expor dados reais.

## Seguranca

Regras importantes de seguranca:

- nunca expor a `service_role key` no app;
- usar a `anon key` apenas conforme regras de seguranca;
- ativar RLS nas tabelas antes de dados reais;
- separar permissoes de visitante, consumidor, estabelecimento e administrador;
- manter dados sensiveis protegidos;
- evitar guardar dados pessoais sem necessidade;
- considerar LGPD desde o inicio.

A separacao futura de permissoes deve respeitar os perfis planejados:

- visitante;
- consumidor;
- estabelecimento;
- administrador da plataforma.

## Integracao com Flutter

A integracao com Flutter sera feita apenas em ciclo futuro e aprovado.

Neste ciclo:

- nao instalar pacote Supabase;
- nao alterar `pubspec.yaml`;
- nao alterar codigo Flutter;
- nao alterar telas;
- nao alterar dados mockados;
- nao conectar o app ao Supabase;
- nao substituir mocks por dados reais.

O aplicativo continua funcionando como MVP 1 mockado.

## Checklist de criacao do projeto Supabase

Use esta lista para conferir se a criacao inicial foi concluida:

- conta Supabase criada;
- projeto Supabase criado;
- regiao definida;
- senha do banco guardada em local seguro;
- `Project URL` localizada;
- `anon key` localizada;
- `service_role key` localizada e mantida em sigilo;
- decisao pendente sobre metodos de login;
- decisao pendente sobre Storage;
- decisao pendente sobre execucao do schema.

## Proximo passo sugerido

O proximo passo recomendado e criar o documento `SUPABASE_SCHEMA_SQL_DRAFT.md`.

Esse documento deve conter uma proposta inicial de SQL para Fase A e Fase B, ainda sem executar nada no Supabase.

Esse futuro rascunho deve servir apenas para revisao tecnica antes de qualquer criacao real de tabelas.
