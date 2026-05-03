# Pe na Areia - Plano de seed inicial para Supabase

## Aviso inicial

Este documento e apenas um plano de seed para revisao futura.

- Nenhum SQL deve ser executado a partir deste documento.
- Nenhum dado real foi criado no Supabase.
- O app continua mockado no MVP 1.
- Este documento nao implementa Supabase, backend, login, pedido, pagamento, reserva, comanda, cashback real ou integracoes externas.
- Dados reais de estabelecimentos precisarao de autorizacao, revisao e validacao antes de qualquer publicacao.

## Objetivo dos seeds

Os seeds futuros devem criar dados iniciais suficientes para testar o MVP 1 real quando o backend Supabase/PostgreSQL for aprovado.

Objetivos principais:

- criar dados iniciais para testar o MVP 1 real;
- permitir exibicao publica da praia de Boa Viagem;
- permitir testes com estabelecimentos aprovados;
- permitir testes de cardapio e disponibilidade;
- preparar uma base para futura substituicao progressiva dos mocks atuais.

## Dados iniciais da praia

Registro sugerido para a tabela futura `beaches`:

| Campo | Valor sugerido |
| --- | --- |
| Nome | Boa Viagem |
| Slug | `boa-viagem` |
| Cidade | Recife |
| Estado | PE |
| Pais | Brasil |
| Bairro/regiao | Boa Viagem |
| Status | `active` |
| Observacao | Coordenadas reais devem ser confirmadas antes de producao. |

## Estabelecimentos iniciais de teste

Os estabelecimentos abaixo sao ficticios e servem apenas para demonstracao, testes internos e validacao futura do MVP 1 real. Eles nao representam estabelecimentos reais.

### Bar Atlantico

| Campo | Valor sugerido |
| --- | --- |
| Nome | Bar Atlantico |
| Descricao | Bar de praia ficticio com foco em bebidas geladas, petiscos simples e atendimento rapido na orla. |
| Status sugerido | `approved` |
| `operation_type` | `bar` |
| Faixa de preco | Media |
| Conjuntos totais | 24 |
| Conjuntos livres iniciais | 8 |
| Cashback resumo | Texto demonstrativo de ate 5% em itens selecionados, sem cashback real. |
| Endereco/ponto de referencia ficticio | Orla de Boa Viagem, proximo a um posto ficticio de apoio. |
| Coordenadas | Pendentes. Usar coordenadas aproximadas ficticias apenas em ambiente de teste, nunca em producao. |
| Observacao | Dado de demonstracao. Nao e estabelecimento real. |

### Mare Alta Beach Bar

| Campo | Valor sugerido |
| --- | --- |
| Nome | Mare Alta Beach Bar |
| Descricao | Beach bar ficticio com drinks, cervejas e petiscos para testes de exibicao premium no app. |
| Status sugerido | `approved` |
| `operation_type` | `beach_tent` |
| Faixa de preco | Media-alta |
| Conjuntos totais | 32 |
| Conjuntos livres iniciais | 14 |
| Cashback resumo | Texto demonstrativo de ate 7% em bebidas e petiscos, sem cashback real. |
| Endereco/ponto de referencia ficticio | Trecho central ficticio da orla de Boa Viagem. |
| Coordenadas | Pendentes. Usar coordenadas aproximadas ficticias apenas em ambiente de teste, nunca em producao. |
| Observacao | Dado de demonstracao. Nao e estabelecimento real. |

### Barraca Coqueiral

| Campo | Valor sugerido |
| --- | --- |
| Nome | Barraca Coqueiral |
| Descricao | Barraca ficticia com agua de coco, queijo coalho, porcoes e estrutura basica de praia. |
| Status sugerido | `approved` |
| `operation_type` | `beach_tent` |
| Faixa de preco | Economica |
| Conjuntos totais | 18 |
| Conjuntos livres iniciais | 5 |
| Cashback resumo | Texto demonstrativo de ate 3% em produtos selecionados, sem cashback real. |
| Endereco/ponto de referencia ficticio | Ponto ficticio proximo ao calcadao de Boa Viagem. |
| Coordenadas | Pendentes. Usar coordenadas aproximadas ficticias apenas em ambiente de teste, nunca em producao. |
| Observacao | Dado de demonstracao. Nao e estabelecimento real. |

### Orla Premium

| Campo | Valor sugerido |
| --- | --- |
| Nome | Orla Premium |
| Descricao | Estabelecimento ficticio com proposta mais sofisticada, frutos do mar e estrutura ampliada. |
| Status sugerido | `approved` |
| `operation_type` | `beach_restaurant` |
| Faixa de preco | Alta |
| Conjuntos totais | 40 |
| Conjuntos livres iniciais | 20 |
| Cashback resumo | Texto demonstrativo de ate 10% em itens selecionados, sem cashback real. |
| Endereco/ponto de referencia ficticio | Area ficticia da orla com maior estrutura de atendimento. |
| Coordenadas | Pendentes. Usar coordenadas aproximadas ficticias apenas em ambiente de teste, nunca em producao. |
| Observacao | Dado de demonstracao. Nao e estabelecimento real. |

## Categorias iniciais de cardapio

Categorias sugeridas para a tabela futura `menu_categories`:

| Ordem | Categoria | Observacao |
| --- | --- | --- |
| 1 | Bebidas | Bebidas nao alcoolicas em geral. |
| 2 | Cervejas | Cervejas em lata, long neck ou similares. |
| 3 | Drinks | Drinks com ou sem alcool. |
| 4 | Petiscos | Porcoes e itens rapidos. |
| 5 | Frutos do mar | Itens de peixe, camarao e similares. |
| 6 | Refeicoes | Pratos principais e refeicoes completas. |
| 7 | Sobremesas | Itens doces. |
| 8 | Estrutura | Itens ligados a uso de conjunto, guarda-sol, cadeira e apoio. |

## Produtos iniciais de teste

Os produtos abaixo sao ficticios ou equivalentes aos mocks atuais. Os precos sao apenas sugestoes para teste e nao devem ser tratados como precos reais.

| Produto | Categoria | Descricao | Marca | Preco sugerido | Cashback percentual | Status | Observacao |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Agua mineral 500ml | Bebidas | Garrafa individual de agua mineral sem gas. | Pendente | R$ 5,00 | 0% | `available` | Preco ficticio. |
| Coca-Cola lata | Bebidas | Refrigerante em lata de 350ml. | Coca-Cola | R$ 7,00 | 0% | `available` | Preco ficticio. |
| Agua de coco | Bebidas | Agua de coco servida gelada. | Nao se aplica | R$ 8,00 | 0% | `available` | Preco ficticio. |
| Heineken long neck | Cervejas | Cerveja long neck de 330ml. | Heineken | R$ 14,00 | 3% | `available` | Preco ficticio. Cashback apenas demonstrativo. |
| Brahma lata | Cervejas | Cerveja em lata de 350ml. | Brahma | R$ 8,00 | 2% | `available` | Preco ficticio. Cashback apenas demonstrativo. |
| Queijo coalho | Petiscos | Espeto de queijo coalho assado. | Nao se aplica | R$ 12,00 | 2% | `available` | Preco ficticio. |
| Batata frita | Petiscos | Porcao de batata frita para compartilhar. | Nao se aplica | R$ 28,00 | 3% | `available` | Preco ficticio. |
| Camarao alho e oleo | Frutos do mar | Porcao de camarao no alho e oleo. | Nao se aplica | R$ 68,00 | 5% | `available` | Preco ficticio. |
| Isca de peixe | Frutos do mar | Porcao de iscas de peixe empanadas. | Nao se aplica | R$ 45,00 | 4% | `available` | Preco ficticio. |
| Conjunto guarda-sol + 2 cadeiras | Estrutura | Uso de um guarda-sol com duas cadeiras durante periodo definido pelo estabelecimento. | Nao se aplica | R$ 35,00 | 0% | `available` | Preco ficticio. Nao representa reserva real. |

Observacoes:

- O campo de cashback deve ser tratado apenas como texto ou percentual demonstrativo enquanto nao houver ciclo aprovado de cashback real.
- Precos futuros em banco devem seguir a decisao tecnica de usar centavos, quando a tabela real for criada.
- Disponibilidade de produto deve usar `available` ou `unavailable`, conforme schema futuro aprovado.

## Disponibilidade inicial

A disponibilidade inicial pode ser registrada futuramente como snapshots agregados por estabelecimento, seguindo a ideia da tabela `establishment_availability_snapshots`.

Cada snapshot deve registrar:

- estabelecimento;
- total de conjuntos;
- conjuntos livres;
- conjuntos ocupados, se houver esse controle;
- etiqueta publica opcional, como "alta", "media" ou "baixa";
- origem da informacao, como admin, estabelecimento ou importacao futura;
- data e hora do snapshot;
- data de criacao do registro.

Exemplo conceitual, nao executavel:

| Estabelecimento | Total de conjuntos | Conjuntos livres | Etiqueta sugerida | Origem | Data/hora do snapshot |
| --- | --- | --- | --- | --- | --- |
| Bar Atlantico | 24 | 8 | Media | Manual | A definir no momento do seed real. |
| Mare Alta Beach Bar | 32 | 14 | Alta | Manual | A definir no momento do seed real. |
| Barraca Coqueiral | 18 | 5 | Media | Manual | A definir no momento do seed real. |
| Orla Premium | 40 | 20 | Alta | Manual | A definir no momento do seed real. |

No MVP 1 real, essa disponibilidade ainda podera ser atualizada manualmente. Ela nao deve depender de QR Code, reserva, pedido, comanda ou controle individual de cada conjunto nesta primeira fase.

## Dados que nao devem entrar como seed inicial

Nao incluir no seed inicial:

- usuarios reais;
- senhas;
- dados pessoais;
- pagamentos;
- cartoes;
- dados fiscais;
- avaliacoes reais;
- cashback real;
- reservas;
- comandas;
- pedidos reais;
- QR Codes reais.

Esses dados exigem ciclos proprios de produto, seguranca, LGPD, RLS e implementacao.

## Cuidados antes de usar dados reais

Antes de qualquer seed com dados reais, validar:

- autorizacao formal do estabelecimento;
- endereco e ponto de referencia;
- fotos e direito de uso das imagens;
- cardapio, descricoes e precos;
- horarios e status de funcionamento;
- responsabilidade sobre informacoes publicas;
- requisitos de LGPD;
- termos de adesao do bar;
- regras para exibicao publica no app;
- processo de correcao ou remocao de informacoes incorretas.

## Proximo passo sugerido

Criar `SUPABASE_IMPLEMENTATION_CHECKLIST.md` com um checklist antes de criar o projeto, tabelas reais, policies, seeds ou qualquer dado no Supabase.

Esse checklist deve continuar sem executar SQL e deve servir para revisar seguranca, RLS, dados publicos, LGPD, ownership do projeto Supabase e ordem correta de implementacao.
