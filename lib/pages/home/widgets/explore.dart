import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Explore extends StatelessWidget {
  Explore({super.key});

  final _plantsStream = Supabase.instance.client
      .from('plants')
      .stream(primaryKey: ['id_plant'])
      .limit(5)
      .order('id_plant', ascending: false)
      .map((event) => event.map((e) => e as Map<String, dynamic>).toList());

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
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _plantsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final List<Map<String, dynamic>> plantsData = snapshot.data ?? [];

          if (plantsData.isEmpty) {
            return const Center(
              child: Text(
                'No plants found. Add a plant to get started!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return Column(
            children: plantsData.map((plant) {
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
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset(
                            plant['icon'] ?? 'assets/default_image.png',
                            width: 60,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plant['name'] ?? 'Unknown',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                plant['variety'] ?? 'Unknown',
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
              );
            }).toList(),
          );
        }
      },
    );
  }

  void _showConfirmationDialog(BuildContext context, Map<String, dynamic> plant) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Addition'),
          content: Text('Are you sure you want to add ${plant['name']}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _addPlant(plant);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addPlant(Map<String, dynamic> plant) async {
    try {
      await _updatePlant(plant['id_plant']);
    } catch (error) {
      // Handle errors if necessary
    }
  }

  Future<void> _updatePlant(int plantId) async {
    try {
      // Fetch current plant in the house
      final response = await Supabase.instance.client
          .from('plants')
          .select('id_plant')
          .eq('id_house', 2);

      if (response== null || response.isEmpty) {
        return;
      }

      final actualPlantId = response[0]['id_plant'];

      // Remove the current plant from the house
      await Supabase.instance.client
          .from('plants')
          .update({'id_house': 0})
          .eq('id_plant', actualPlantId);

      // Add the new plant to the house
      final updateResponse = await Supabase.instance.client
          .from('plants')
          .update({'id_house': 2})
          .eq('id_plant', plantId);

      if (updateResponse.error != null) {
        throw updateResponse.error!.message;
      }
    } catch (error) {
      // Handle errors if necessary
      throw Exception('Failed to update plant: $error');
    }
  }
}
