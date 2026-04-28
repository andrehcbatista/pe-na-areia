# Pé na Areia — Instruções para agentes de código

## Visão do produto
O Pé na Areia é uma plataforma mobile/web para descoberta e consumo em bares de praia. A praia-piloto é Boa Viagem, Recife/PE.

## Fase atual
MVP 1 — Consulta pública de estabelecimentos, cardápios, mapa/lista, status, distância e disponibilidade de conjuntos.

## Fora do escopo atual
Não implementar ainda:
- login;
- pagamento;
- pedido;
- comanda;
- reserva;
- cashback real;
- ambulantes;
- QR Code funcional;
- backend real;
- Google Maps real.

## Estilo visual
- Fundo branco.
- Azul oceano como cor primária.
- Violeta como cor secundária.
- Coral/laranja apenas para destaques.
- Estética premium, limpa e sofisticada.
- Referências: iFood, Uber, 99, Airbnb, Booking, Rappi e Waze.

## Regras técnicas
- Manter código modular.
- Evitar arquivos gigantes.
- Separar models, mock data, screens, widgets e theme.
- Não adicionar dependências sem justificar.
- Não remover funcionalidades existentes sem autorização.
- Não alterar escopo aprovado.
- Sempre explicar alterações realizadas.

## Regras de produto
- A localização considerada é a do estabelecimento, não dos conjuntos.
- O QR Code futuro identificará o conjunto físico móvel.
- O código manual do conjunto será alternativa ao QR Code.
- O pedido futuro poderá ser feito diretamente no bar ou vinculado a conjunto.
- A reserva será fase posterior e exigirá crédito mínimo.

## Regra de segurança de escopo
Antes de implementar qualquer funcionalidade fora do MVP 1, perguntar ao usuário e aguardar aprovação.
