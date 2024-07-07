import 'package:flutter/material.dart';
import 'package:gardenapp/models/plant.dart';
import 'package:gardenapp/pages/detail/widgets/detail_sliver.dart';
import 'package:gardenapp/pages/detail/widgets/info.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailPage extends StatelessWidget {
  final int id;
  final supabase = Supabase.instance.client;

  DetailPage(this.id, {super.key});

  Future<Plant?> fetchData(int id) async {
    final response = await supabase
        .from('plants')
        .select('id_plant, name, bg_image, icon, variety, description, plant_indicators(water_need, temp_max, temp_min)')
        .eq('id_plant', id)
        .single();

    if (response.isEmpty) {
      throw Exception('No data found');
    } else {
      return Plant.fromMap(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Plant?>(
      future: fetchData(id),
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
