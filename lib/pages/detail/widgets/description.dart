import 'package:flutter/material.dart';
import 'package:garden_app/models/plant.dart';
import 'package:readmore/readmore.dart';

class DescriptionSection extends StatelessWidget {
  final Plant plant;
  const DescriptionSection(this.plant, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: ReadMoreText(
        plant.description,
        trimLines: 2,
        colorClickableText: Colors.green,
        trimMode: TrimMode.Line,
        trimCollapsedText: 'More',
        trimExpandedText: ' Less',
        style: TextStyle(
          color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
          height: 2,
        ),
      ),
    );
  }
}
