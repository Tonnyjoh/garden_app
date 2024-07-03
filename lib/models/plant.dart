class Plant {
  num id;
  String bgImage;
  String icon;
  String name;
  String type;
  num waterNeed;
  num lightNeed;
  num temperatureNeed;
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
        'assets/images/tom1.jpg',
        'assets/images/tomlogo.png',
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
        'assets/images/cact1.jpeg',
        'assets/images/cactlogo.png',
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
