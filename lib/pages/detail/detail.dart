import 'package:flutter/material.dart';
import 'package:gardenapp/models/plant.dart';
import 'package:gardenapp/pages/detail/widgets/detail_sliver.dart';
import 'package:gardenapp/pages/detail/widgets/info.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rxdart/rxdart.dart';

class DetailPage extends StatelessWidget {
  final int id;
  final supabase = Supabase.instance.client;

  DetailPage(this.id, {super.key});

  Stream<Plant?> fetchPlantStream(int id) {
    // Stream for the plants table
    Stream<List<Map<String, dynamic>>> plantStream = supabase
        .from('plants')
        .stream(primaryKey: ['id_plant'])
        .eq('id_plant', id);

    // Stream for the plant_indicators table
    Stream<List<Map<String, dynamic>>> indicatorStream = supabase
        .from('plant_indicators')
        .stream(primaryKey: ['id_indicator'])
        .eq('id_plant', id);

    // Combine the two streams and map them to a Plant object
    return CombineLatestStream.combine2(
      plantStream,
      indicatorStream,
          (List<Map<String, dynamic>> plantList, List<Map<String, dynamic>> indicatorList) {
        //print('Plant data: $plantList'); // Log plant data
        //print('Indicator data: $indicatorList'); // Log indicator data

        if (plantList.isNotEmpty) {
          final plantData = plantList.first;
          final plantIndicators = indicatorList.map((indicatorData) {
            return PlantIndicator.fromMap(indicatorData);
          }).toList();

          final plant = Plant(
            id: plantData['id_plant'] as int,
            name: plantData['name'] as String,
            bgImage: plantData['bg_image'] as String,
            icon: plantData['icon'] as String,
            variety: plantData['variety'] as String,
            description: plantData['description'] as String,
            plantIndicators: plantIndicators,
          );

          //print('Constructed plant: $plant'); // Log constructed plant

          return plant;
        } else {
          return null;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Plant?>(
      stream: fetchPlantStream(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          final Plant plant = snapshot.data!;
          //print('Plant data in build: $plant'); // Log plant data in build
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                // Top part of the detail page
                SliverPersistentHeader(
                  delegate: DetailSliverDelegate(
                    plant: plant,
                    expandedHeight: 360,
                    roundedContainerHeight: 30,
                  ),
                ),
                // Bottom part of the detail page
                SliverToBoxAdapter(
                  child: PlantInfo(plant),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: Text('No data available'),
          );
        }
      },
    );
  }
}
