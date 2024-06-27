import 'package:flutter/material.dart';
import 'package:garden_app/models/plant.dart';

class GallerySection extends StatelessWidget {
  final Plant plant;
  const GallerySection(this.plant, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => SizedBox(
          width: 250,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              plant.images[index],
              fit: BoxFit.cover,
            ),
          ),
        ),
        separatorBuilder: (context, index) => const SizedBox(width: 15),
        itemCount: plant.images.length,
      ),
    );
  }
}
