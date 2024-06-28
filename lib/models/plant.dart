class Plant {
  num id;
  String bgImage;
  String icon;
  String name;
  String type;
  num waterNeed; // Renommé de score à waterNeed
  num lightNeed; // Renommé de download à lightNeed
  num temperatureNeed; // Renommé de review à temperatureNeed
  String description;
  List<String> images;
  List<String> notifications;

  Plant(
    this.id,
    this.bgImage,
    this.icon,
    this.name,
    this.type,
    this.waterNeed, // Renommé
    this.lightNeed, // Renommé
    this.temperatureNeed, // Renommé
    this.description,
    this.images,
    this.notifications,
  );

  static List<Plant> plants() {
    return [
      Plant(
        0,
        'assets/images/ori1.jpg',
        'assets/images/ori_logo.png',
        'Tomate et voatabia',
        'Fruit atao hoe legume',
        1, // besoin en eau
        10, // besoin en lumière
        24, // température idéale
        "tomate et voatabia tomate et voatabiatomate et voatabiatomate et voatabiatomate et voatabiatomate et voatabiatomate et voatabiatomate et voatabiatomate et voatabiatomate et voatabiatomate et voatabiatomate et voatabiatomate et voatabiatomate et voatabiatomate et voatabiatomate et voatabiatomate et voatabia",
        [
          'assets/images/ori2.jpg',
          'assets/images/ori3.jpg',
          'assets/images/ori4.jpg',
        ],
        [
          'Water in 30 minutes',
          'Fertilize soil in 2 days',
        ],
      ),
      Plant(
        1,
        'assets/images/rl1.jpg',
        'assets/images/rl_logo.png',
        'Cactus',
        'Misy tsilo ee',
        0.1,
        15,
        30,
        "Feno tsilo le izy...",
        [
          'assets/images/rl2.jpg',
          'assets/images/rl3.jpg',
          'assets/images/rl4.jpg',
          'assets/images/rl5.jpg',
        ],
        [
          'Water in 3 hour',
        ],
      ),
    ];
  }
}
