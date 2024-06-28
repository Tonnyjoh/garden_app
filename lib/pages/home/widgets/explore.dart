import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:garden_app/models/plant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NewestPlant extends StatelessWidget {
  NewestPlant({super.key});

  // Récupération de la liste des plantes à partir du modèle
  final List<Plant> plants = Plant.plants();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: plants
            .map(
              (plant) => Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.only(bottom: 20),
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
                child: Stack(
                  clipBehavior: Clip.none, // Permet au contenu de dépasser
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset(
                            plant.icon,
                            width: 60,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plant.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Row(
                              //   children: [
                              //     _buildWaterIcon(plant.waterNeed.toDouble()),
                              //     const SizedBox(width: 10),
                              //     _buildTemperatureIcon(
                              //         plant.temperatureNeed.toDouble()),
                              //   ],
                              // ),
                              Text(
                                plant.type,
                                style: TextStyle(
                                  color: Colors.grey.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: -20,
                      right: -20,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        child: IconButton(
                          onPressed: () {
                            print('Button pressed!');
                          },
                          icon: const Icon(Icons.add),
                          color: Colors.white,
                          iconSize: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildWaterIcon(double waterNeed) {
    int filledDrops =
        (waterNeed / 2).round(); // Assuming waterNeed is out of 10
    int totalDrops = 5;

    return Row(
      children: List.generate(totalDrops, (index) {
        return Icon(
          FontAwesomeIcons.droplet,
          color:
              index < filledDrops ? Colors.blue : Colors.grey.withOpacity(0.5),
          size: 20,
        );
      }),
    );
  }

  Widget _buildTemperatureIcon(double temperatureNeed) {
    int filledTemps =
        (temperatureNeed / 10).round(); // Assuming temperatureNeed is out of 50
    int totalTemps = 5;

    return Row(
      children: List.generate(totalTemps, (index) {
        return Icon(
          CupertinoIcons.thermometer,
          color: index < filledTemps
              ? Colors.orange
              : Colors.grey.withOpacity(0.5),
          size: 20,
        );
      }),
    );
  }
}
