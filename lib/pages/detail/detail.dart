import 'package:flutter/material.dart';
import 'package:gardenapp/models/plant.dart';
import 'package:gardenapp/pages/detail/widgets/detail_sliver.dart';
import 'package:gardenapp/pages/detail/widgets/info.dart';

class DetailPage extends StatelessWidget {
  const DetailPage(this.plant, {super.key});

  final Plant plant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //tapany ambony amle detail
          SliverPersistentHeader(
            delegate: DetailSliverDelegate(
              plant: plant,
              expandedHeight: 360,
              roundedContainerHeight: 30,
            ),
          ),
          //tapany ambany amle detail
          SliverToBoxAdapter(
            child: PlantInfo(plant),
          )
        ],
      ),
    );
  }
}
