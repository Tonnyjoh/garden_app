class Percentage {
  final String categories;
  final int percent; // Pourcentage du niveau optimal atteint
  final int value; // Valeur totale ou coût associé

  const Percentage({
    required this.categories,
    required this.percent,
    required this.value,
  });
}

final percentageList = [
  const Percentage(categories: "Azote", percent: 70, value: 50),
  const Percentage(categories: "Phosphore", percent: 85, value: 30),
  const Percentage(categories: "Potassium", percent: 60, value: 40),
];
