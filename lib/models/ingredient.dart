enum Unit {
  g('g'),
  kg('kg'),
  ml('ml'),
  l('L'),
  piece('pièce(s)');

  final String label; // ajoute la propriété label
  const Unit(this.label); // constructeur pour chaque valeur
}

class Ingredient {
  final String name;
  final double quantity;
  final Unit unit;

  Ingredient({
    required this.name,
    required this.quantity,
    required this.unit,
  });
}
