import '../../models/menu_category.dart';
import '../../models/menu_item.dart';

const _categoryNames = {
  'bebidas': 'Bebidas',
  'cervejas': 'Cervejas',
  'drinks': 'Drinks',
  'petiscos': 'Petiscos',
  'frutos-do-mar': 'Frutos do mar',
  'refeicoes': 'Refeicoes',
  'sobremesas': 'Sobremesas',
  'estrutura': 'Estrutura',
};

const mockMenuItems = [
  MenuItem(
    id: 'agua-coco',
    establishmentId: 'all',
    categoryId: 'bebidas',
    name: 'Agua de coco',
    description: 'Coco natural servido gelado.',
    price: 9,
    cashbackPercent: 5,
    isHighlighted: true,
  ),
  MenuItem(
    id: 'suco-abacaxi-hortela',
    establishmentId: 'all',
    categoryId: 'bebidas',
    name: 'Suco de abacaxi com hortela',
    description: 'Suco natural batido na hora.',
    price: 14,
    cashbackPercent: 3,
  ),
  MenuItem(
    id: 'lager-premium',
    establishmentId: 'all',
    categoryId: 'cervejas',
    name: 'Lager premium 600ml',
    description: 'Garrafa compartilhavel servida no balde.',
    price: 18,
    brand: 'Boa Viagem Lager',
    cashbackPercent: 4,
  ),
  MenuItem(
    id: 'long-neck',
    establishmentId: 'all',
    categoryId: 'cervejas',
    name: 'Long neck',
    description: 'Opcoes pilsen e puro malte.',
    price: 12,
    brand: 'Sol Praia',
    isAvailable: false,
  ),
  MenuItem(
    id: 'gin-tropical',
    establishmentId: 'all',
    categoryId: 'drinks',
    name: 'Gin tropical',
    description: 'Gin, citricos, especiarias e tonica.',
    price: 32,
    brand: 'Gin Recife',
    cashbackPercent: 6,
    isHighlighted: true,
  ),
  MenuItem(
    id: 'caipiroska-limao',
    establishmentId: 'all',
    categoryId: 'drinks',
    name: 'Caipiroska de limao',
    description: 'Vodka, limao e acucar na medida.',
    price: 24,
  ),
  MenuItem(
    id: 'isca-peixe',
    establishmentId: 'all',
    categoryId: 'petiscos',
    name: 'Isca de peixe',
    description: 'Peixe empanado com molho da casa.',
    price: 46,
    cashbackPercent: 5,
    isHighlighted: true,
  ),
  MenuItem(
    id: 'batata-rustica',
    establishmentId: 'all',
    categoryId: 'petiscos',
    name: 'Batata rustica',
    description: 'Batata crocante com aioli de ervas.',
    price: 28,
    isAvailable: false,
  ),
  MenuItem(
    id: 'camarao-alho-oleo',
    establishmentId: 'all',
    categoryId: 'frutos-do-mar',
    name: 'Camarao alho e oleo',
    description: 'Camarao salteado com alho dourado.',
    price: 72,
    cashbackPercent: 8,
    isHighlighted: true,
  ),
  MenuItem(
    id: 'caldinho-sururu',
    establishmentId: 'all',
    categoryId: 'frutos-do-mar',
    name: 'Caldinho de sururu',
    description: 'Receita regional em porcao individual.',
    price: 16,
  ),
  MenuItem(
    id: 'peixe-grelhado',
    establishmentId: 'all',
    categoryId: 'refeicoes',
    name: 'Peixe grelhado',
    description: 'Acompanha arroz, farofa e vinagrete.',
    price: 58,
  ),
  MenuItem(
    id: 'moqueca-praia',
    establishmentId: 'all',
    categoryId: 'refeicoes',
    name: 'Moqueca da praia',
    description: 'Porcao para duas pessoas com pirao.',
    price: 128,
    cashbackPercent: 10,
    isHighlighted: true,
  ),
  MenuItem(
    id: 'cartola',
    establishmentId: 'all',
    categoryId: 'sobremesas',
    name: 'Cartola pernambucana',
    description: 'Banana, queijo manteiga, canela e acucar.',
    price: 22,
  ),
  MenuItem(
    id: 'sorvete-artesanal',
    establishmentId: 'all',
    categoryId: 'sobremesas',
    name: 'Sorvete artesanal',
    description: 'Sabores tropicais conforme disponibilidade.',
    price: 18,
    brand: 'Gelato Boa Viagem',
    isAvailable: false,
  ),
  MenuItem(
    id: 'conjunto-simples',
    establishmentId: 'all',
    categoryId: 'estrutura',
    name: 'Conjunto guarda-sol',
    description: 'Guarda-sol com duas cadeiras. Item apenas demonstrativo.',
    price: 35,
  ),
  MenuItem(
    id: 'conjunto-premium',
    establishmentId: 'all',
    categoryId: 'estrutura',
    name: 'Conjunto premium',
    description: 'Mesa lateral, quatro cadeiras e sombreiro maior.',
    price: 60,
    cashbackPercent: 7,
    isHighlighted: true,
  ),
];

List<MenuCategory> menuForEstablishment(String establishmentId) {
  return _categoryNames.entries.map((entry) {
    final items = mockMenuItems
        .where(
          (item) =>
              item.categoryId == entry.key &&
              (item.establishmentId == establishmentId ||
                  item.establishmentId == 'all'),
        )
        .toList();

    return MenuCategory(id: entry.key, title: entry.value, items: items);
  }).toList();
}
