import 'package:flutter/material.dart';
import 'package:gardenapp/models/plant.dart';

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
                        print('Button pressed!'); // Vérifiez que ce message s'affiche
                        _showCustomSnackBar(context);
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

  void _showCustomSnackBar(BuildContext context) {
    final overlay = Overlay.of(context);
    final snackBar = OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child:const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Text(
                  'It\'s now the new plant in the greenhouse.',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Icon(Icons.check, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(snackBar);
    Future.delayed(const Duration(seconds: 3), () {
      snackBar.remove();
    });
  }


}
