# Decisões Técnicas — Pé na Areia

## Decisão

Usar Supabase como backend futuro do Pé na Areia.

## Contexto

O Pé na Areia é um marketplace e plataforma de consumo em praias, começando pela praia-piloto de Boa Viagem, Recife/PE.

No futuro, a plataforma poderá envolver perfis diferentes de usuários, estabelecimentos, cardápios, conjuntos físicos, pedidos, comandas, pagamentos, cashback, reservas e avaliações.

Essas funcionalidades criam muitas relações entre entidades, como consumidores, estabelecimentos, produtos, pedidos, itens de pedido, comandas, pagamentos, reservas e permissões de acesso.

## Justificativa

A escolha recomendada para o backend futuro é Supabase pelos seguintes motivos:

- O modelo de dados do Pé na Areia é altamente relacional.
- PostgreSQL é mais adequado para entidades relacionadas, regras de integridade e consultas estruturadas.
- Supabase Auth pode atender à autenticação futura de consumidores, estabelecimentos e administradores.
- Row Level Security será útil para separar permissões por perfil e restringir acesso aos dados corretos.
- Supabase Storage poderá armazenar imagens de estabelecimentos, produtos e outros arquivos públicos ou privados.
- Supabase Edge Functions poderão ser usadas futuramente para webhooks, pagamentos e regras de negócio.
- O painel do Supabase ajudará na administração inicial do banco de dados durante os primeiros ciclos reais de backend.

## Comparação resumida com Firebase

Firebase é excelente para apps mobile, sincronização realtime e desenvolvimento rápido de aplicações com dados menos relacionais.

Firestore, porém, é um banco NoSQL. Para o Pé na Areia, Supabase com PostgreSQL tende a ser mais natural por causa de pedidos, comandas, pagamentos, perfis, estabelecimentos, cardápios e demais relacionamentos entre entidades.

## Arquitetura futura sugerida

- Flutter.
- Supabase Auth.
- Supabase PostgreSQL.
- Supabase Storage.
- Supabase Edge Functions.
- Provedor de pagamento com split a definir.
- Serviço de mapas a definir.

## Perfis futuros

- visitante;
- consumidor logado;
- estabelecimento;
- administrador da plataforma.

## Regra importante

O projeto ainda está no MVP 1 mockado. Supabase não deve ser integrado agora sem um ciclo específico aprovado.

Esta decisão registra uma direção técnica futura, mas não autoriza implementação de backend, autenticação, pagamentos, reservas, comandas, cashback real, integrações externas ou alteração do escopo atual do MVP 1.

## Próximos passos após esta decisão

Quando houver aprovação para iniciar um ciclo específico de backend, os próximos passos sugeridos são:

- criar conta Supabase;
- criar projeto Supabase;
- modelar banco real;
- criar tabelas iniciais;
- configurar RLS;
- implementar autenticação;
- separar perfis;
- migrar dados mockados para dados reais progressivamente.
