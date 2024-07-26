import 'package:flutter/material.dart';
import 'package:gardenapp/pages/home/widgets/realtime_indicator.dart';

import 'explore.dart';
import 'myplants.dart';

class MenuSection extends StatelessWidget {
  const MenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF6F8FF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
             const IndicatorWidget(), // Utilisation du nouveau widget
             const SizedBox(height: 10),
              const Text(
                'My plants',
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'CaviarDreams',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              MyPlants(),
              const SizedBox(height: 10),
              const Text(
                'Explore',
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'CaviarDreams',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              NewestPlant(), // Utilisation de NewestPlant comme avant
            ],
          ),
        ),
      ),
    );
  }
}
