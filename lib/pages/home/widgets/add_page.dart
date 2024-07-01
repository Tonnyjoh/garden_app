import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gardenapp/models/plant.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Exemple de données de plantes plus complètes
    final List<Plant> plants = Plant.plants();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Plant'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(25),
        child: ListView.builder(
          itemCount: plants.length,
          itemBuilder: (context, index) {
            final plant = plants[index];
            return Container(
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
              child: Row(
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
                        Row(
                          children: [
                            Text(
                              plant.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.droplet,
                              color: Colors.blue,
                              size: 16,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Water need: ${plant.waterNeed}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(
                              CupertinoIcons.thermometer,
                              color: Colors.orange,
                              size: 16,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Temperature need: ${plant.temperatureNeed}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.info,
                              color: Colors.grey,
                              size: 16,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                plant.type,
                                style: const TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print('Added plant with ID: ${plant.id}');
                      _showCustomSnackBar(context, plant.name);
                      // Implémentez la logique d'ajout ici
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                      backgroundColor: Colors.green, // couleur du bouton
                      foregroundColor: Colors.white, // couleur de l'icône
                    ),
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showCustomSnackBar(BuildContext context, String plantName) {
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$plantName has been added',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const Icon(Icons.check, color: Colors.white),
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
