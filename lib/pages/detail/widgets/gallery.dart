import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gardenapp/models/plant.dart';

class GallerySection extends StatelessWidget {
  final Plant plant;
  const GallerySection(this.plant, {Key? key}) : super(key: key);

  static TextStyle labelStyle = const TextStyle(
    fontSize: 15,
    color: Colors.black54,
    fontFamily: 'CaviarDreams',
  );

  static TextStyle valueStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 0, 0, 0),
    fontFamily: 'CaviarDreams',
  );

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> statistics = [
      {
        'icon': FontAwesomeIcons.droplet,
        'value': '${plant.waterNeed} L/week',
        'label': 'Water',
        'color': Colors.lightBlueAccent,
      },
      {
        'icon': FontAwesomeIcons.temperatureHigh,
        'value': '${plant.temperatureNeed}°C',
        'label': 'Temperature',
        'color': Colors.deepOrangeAccent,
      },
      {
        'icon': FontAwesomeIcons.solidSun,
        'value': '${plant.lightNeed} Lux',
        'label': 'Light',
        'color': Colors.amber,
      },
    ];

    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => _buildStatisticItem(statistics[index]),
        separatorBuilder: (context, index) => const SizedBox(width: 15),
        itemCount: statistics.length,
      ),
    );
  }

  Widget _buildStatisticItem(Map<String, dynamic> statistic) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            statistic['icon'],
            size: 40,
            color: statistic['color'],
          ),
          const SizedBox(height: 10),
          Text(
            statistic['value'],
            style: valueStyle,
          ),
          const SizedBox(height: 5),
          Text(
            statistic['label'],
            style: labelStyle,
          ),
        ],
      ),
    );
  }
}
