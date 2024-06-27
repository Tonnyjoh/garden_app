import 'package:flutter/material.dart';
import 'package:garden_app/models/plant.dart';
import 'package:garden_app/pages/detail/widgets/detail_sliver.dart';
import 'package:garden_app/pages/detail/widgets/info.dart';

class DetailPage extends StatelessWidget {
  const DetailPage(this.plant, {super.key});

  final Plant plant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: DetailSliverDelegate(
              plant: plant,
              expandedHeight: 360,
              roundedContainerHeight: 30,
            ),
          ),
          SliverToBoxAdapter(
            child: PlantInfo(plant),
          )
        ],
      ),
    );
  }
}
