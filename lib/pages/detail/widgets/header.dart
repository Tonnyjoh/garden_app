import 'package:flutter/material.dart';
import 'package:gardenapp/models/plant.dart';

class HeaderSection extends StatelessWidget {
  final Plant plant;
  const HeaderSection(this.plant, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              plant.icon,
              width: 80,
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plant.name,
                style: const TextStyle(
                  fontFamily: "CaviarDreams",
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                plant.type,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 123, 123, 123),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
