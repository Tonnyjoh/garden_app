import 'package:flutter/material.dart';
import 'package:garden_app/models/plant.dart';

class HeaderSection extends StatelessWidget {
  final Plant plant;
  const HeaderSection(this.plant, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Image.asset(
            plant.icon,
            width: 80,
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plant.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                plant.type,
                style: TextStyle(
                  color: Colors.grey.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 15,
                      ),
                      Text(
                        plant.score.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 30),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.red,
                        size: 15,
                      ),
                      Text(
                        '${plant.download.toString()} k',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
