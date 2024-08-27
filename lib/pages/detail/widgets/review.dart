import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gardenapp/models/plant.dart';

class ReviewSection extends StatelessWidget {
  final Plant plant;
  const ReviewSection(this.plant, {super.key});

  @override
  Widget build(BuildContext context) {
    double waterNeed = plant.plantIndicators.first.waterNeed;
    double tempMin = plant.plantIndicators.first.tempMin;
    double tempMax = plant.plantIndicators.first.tempMax;

    // Convertir 'waterNeed' en int (arrondir ou tronquer)
    int filledDrops = waterNeed.round();
    int totalDrops = 5;

    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Needs',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(totalDrops, (index) {
                      return Icon(
                        Icons.water_drop_outlined,
                        color: index < filledDrops ? Colors.blue : Colors.grey,
                        size: 20,
                      );
                    }),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Water',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.thermometer,
                        color: Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${tempMin.toStringAsFixed(1)}°C - ${tempMax.toStringAsFixed(1)}°C',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Ideal Temp Range',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          /*const Text(
            'Notifications',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),*/
        ],
      ),
    );
  }
}
