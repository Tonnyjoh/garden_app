// models/plant.dart

class PlantIndicator {
  final int idIndicator;
  final int idPlant;
  final double tempMax;
  final double waterNeed;
  final double tempMin;

  PlantIndicator({
    required this.idIndicator,
    required this.idPlant,
    required this.tempMax,
    required this.waterNeed,
    required this.tempMin,
  });

  factory PlantIndicator.fromMap(Map<String, dynamic> map) {
    return PlantIndicator(
      idIndicator: map['id_indicator'] as int,
      idPlant: map['id_plant'] as int,
      tempMax: (map['temp_max'] as num).toDouble(),
      waterNeed: (map['water_need'] as num).toDouble(),
      tempMin: (map['temp_min'] as num).toDouble(),
    );
  }
}

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
}
