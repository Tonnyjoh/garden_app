import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewestPlant extends StatelessWidget {
  NewestPlant({super.key});

  // Liste des plantes déjà plantées en utilisant un stream pour les données en temps réel
  final _plantsStream = Supabase.instance.client
      .from('plants')
      .stream(primaryKey: ['id_plant'])
      .limit(5);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          _buildPlantsSection(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPlantsSection(BuildContext context) {
    return StreamBuilder(
      stream: _plantsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final List<dynamic> plantsData = snapshot.data as List<dynamic>? ?? [];

          if (plantsData.isEmpty) {
            return const Center(
              child: Text(
                'No plants found. Add a plant to get started!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return Column(
            children: plantsData
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
                  clipBehavior: Clip.none,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset(
                            plant['icon'],
                            width: 60,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plant['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                plant['variety'],
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
                            _showConfirmationDialog(context, plant);
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
          );
        }
      },
    );
  }

  void _showConfirmationDialog(BuildContext context, dynamic plant) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Addition'),
          content: Text('Are you sure you want to add ${plant['name']}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
                _addPlant(context, plant); // Ajouter la plante
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addPlant(BuildContext context, dynamic plant) async {
    try {
      await _updatePlant(plant['id_plant']);
      _showCustomSnackBar(context, 'Plant has been successfully updated!');
    } catch (error) {
      _showCustomSnackBar(context, 'Failed to update plant: $error');
    }
  }

  Future<void> _updatePlant(int plantId) async {
    final response = await Supabase.instance.client
        .from('plants')
        .update({'id_house': 2}) // Mise à jour de l'id_house
        .eq('id_plant', plantId);

    if (response.error != null) {
      throw response.error!.message;
    }
  }

  void _showCustomSnackBar(BuildContext context, String message) {
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
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
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
