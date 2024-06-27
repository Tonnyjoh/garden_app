import 'package:flutter/material.dart';
import 'package:garden_app/models/plant.dart';
import 'package:garden_app/pages/detail/widgets/description.dart';
import 'package:garden_app/pages/detail/widgets/gallery.dart';
import 'package:garden_app/pages/detail/widgets/header.dart';
import 'package:garden_app/pages/detail/widgets/review.dart';

class PlantInfo extends StatelessWidget {
  final Plant plant;

  const PlantInfo(this.plant, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          HeaderSection(plant),
          GallerySection(plant),
          DescriptionSection(plant),
          ReviewSection(plant)
        ],
      ),
    );
  }
}
