import 'package:flutter/material.dart';
import 'package:test_drive/models/plant.dart';
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
        colorClickableText: const Color(0xFF5F67EA),
        trimMode: TrimMode.Line,
        trimCollapsedText: 'Plus',
        trimExpandedText: ' Réduire',
        style: TextStyle(
          color: Colors.grey.withOpacity(0.7),
          height: 1.5,
        ),
      ),
    );
  }
}
