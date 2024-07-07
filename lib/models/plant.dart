class Plant {
  final int id;
  final String name;
  final String bgImage;
  final String icon;
  final String variety;
  final String description;
  final List<PlantIndicator> plantIndicators;

  Plant({
    required this.id,
    required this.name,
    required this.bgImage,
    required this.icon,
    required this.variety,
    required this.description,
    required this.plantIndicators,
  });

  factory Plant.fromMap(Map<String, dynamic> map) {
    return Plant(
      id: map['id_plant'],
      name: map['name'],
      bgImage: map['bg_image'],
      icon: map['icon'],
      variety: map['variety'],
      description: map['description'],
      plantIndicators: (map['plant_indicators'] as List)
          .map((indicator) => PlantIndicator.fromMap(indicator))
          .toList(),
    );
  }
}

class PlantIndicator {
  final double tempMax;
  final double tempMin;
  final double waterNeed;

  PlantIndicator({
    required this.tempMax,
    required this.tempMin,
    required this.waterNeed,
  });

  factory PlantIndicator.fromMap(Map<String, dynamic> map) {
    return PlantIndicator(
      tempMax: map['temp_max'],
      tempMin: map['temp_min'],
      waterNeed: map['water_need'],
    );
  }
}
