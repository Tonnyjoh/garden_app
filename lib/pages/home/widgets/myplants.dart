import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gardenapp/pages/detail/detail.dart';

class MyPlants extends StatelessWidget {
  const MyPlants({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: Supabase.instance.client
          .from('plants')
          .stream(primaryKey: ['id_plant'])
          .asBroadcastStream(),
      initialData: const [],
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<Map<String, dynamic>> plantsData = snapshot.data ?? [];

        final List<Map<String, dynamic>> filteredPlants = plantsData
            .where((plant) => plant['id_house'] == 2)
            .toList();

        if (filteredPlants.isEmpty) {
          return const Center(
            child: Text(
              'No plants found. Add a plant to get started!',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Row(
              key: ValueKey(filteredPlants.length),
              mainAxisAlignment: MainAxisAlignment.center,
              children: filteredPlants.map((plant) => _buildPlantItem(context, plant)).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlantItem(BuildContext context, Map<String, dynamic> plant) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetailPage(plant['id_plant']),
          ),
        );
      },
      child: SizedBox(
        width: 200,
        height: 180,
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius:const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.asset(
                    plant['bg_image'],
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration:const BoxDecoration(
                  color: Colors.white,
                  borderRadius:  BorderRadius.vertical(bottom: Radius.circular(15)),
                ),
                child: Text(
                  plant['name'],
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
