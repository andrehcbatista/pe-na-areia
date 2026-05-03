# Pé na Areia — Estado Atual do Projeto

## 1. Nome do projeto

Pé na Areia

## 2. Praia-piloto

Boa Viagem — Recife/PE

## 3. Estado atual

O projeto está no MVP 1 mockado, com dados locais e sem backend real.

Nesta fase, o objetivo é validar a experiência pública de descoberta de estabelecimentos, cardápios, mapa/lista, status, distância e disponibilidade de conjuntos.

## 4. Funcionalidades já implementadas no protótipo

- Splash Screen;
- Confirmação de praia;
- Home com lista de estabelecimentos;
- Mapa mockado;
- Detalhes do estabelecimento;
- Cardápio com cashback, disponibilidade e botão futuro;
- Solicitação de cadastro de estabelecimento;
- Admin mockado com aprovação/recusa;
- Layout ajustado para mobile;
- Metadados web/PWA ajustados;
- Estrutura modular Flutter.

## 5. Funcionalidades que ainda NÃO existem

- login;
- autenticação;
- perfis reais de usuário;
- backend;
- banco de dados;
- Firebase;
- Supabase;
- pagamento;
- Pix;
- cartão;
- carteira interna;
- cashback real;
- pedido real;
- comanda real;
- reserva;
- QR Code real;
- Google Maps real;
- ambulantes.

## 6. Observação importante sobre perfis

No MVP 1, as telas de cadastro de bar e admin mockado estão acessíveis apenas para validação do fluxo e entendimento da experiência futura.

Essas telas não representam ainda um sistema real de perfis, permissões, autenticação ou gestão operacional.

Futuramente, deverão existir perfis separados:

- visitante;
- consumidor logado;
- estabelecimento;
- administrador da plataforma.

## 7. Separação futura de perfis

### Visitante

Poderá acessar a consulta pública de praia, estabelecimentos, cardápios, disponibilidade, status, mapa/lista e informações básicas sem login.

### Consumidor logado

Poderá ter conta própria para usar funcionalidades futuras como pedido, comanda, cashback interno, avaliações, histórico e reserva, quando essas fases forem aprovadas.

### Estabelecimento

Poderá acessar um painel próprio para gerenciar dados do bar, cardápio, disponibilidade, status, pedidos, comandas, pagamentos e outras operações futuras.

### Administrador da plataforma

Poderá validar cadastros de estabelecimentos, moderar informações, acompanhar operação da plataforma, gerenciar regras de negócio e administrar usuários ou conteúdos quando houver backend real.

## 8. Regras de negócio já definidas

- A localização considerada é a do estabelecimento, não do conjunto;
- O QR Code futuro identificará o conjunto físico móvel;
- O código manual será alternativa ao QR Code;
- O pedido futuro poderá ser feito diretamente no bar ou vinculado a conjunto;
- Reserva será fase posterior;
- Cashback será crédito interno;
- Avaliação será bilateral;
- Pagamentos serão processados pela plataforma futuramente.

## 9. Próximos ciclos sugeridos

- Revisão de estrutura e preparação para backend;
- Escolha entre Firebase e Supabase;
- Modelagem de dados real;
- Autenticação e perfis;
- Painel real do estabelecimento;
- Painel real do administrador;
- Pedido simples;
- QR Code/código manual;
- Comanda;
- Pagamento/cashback;
- Reserva;
- Ambulantes.

## 10. Regra de desenvolvimento

Cada novo ciclo deve ser feito em uma nova tarefa/chat do Codex, com escopo claro e sem misturar funcionalidades.

Ao final de cada ciclo de desenvolvimento, deve haver:

- `flutter analyze`;
- teste local;
- `git commit`;
- `git push`.

Nenhuma funcionalidade fora do MVP 1 deve ser implementada sem aprovação expressa.
