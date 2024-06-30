import 'package:flutter/material.dart';
import 'package:gardenapp/models/plant.dart';
import 'package:gardenapp/pages/detail/detail.dart';

class MyPlants extends StatelessWidget {
  MyPlants({super.key});
  //liste des plantes actuelles
  final List<Plant> plants = Plant.plants();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 20,
        ),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DetailPage(plants[index]),
            ),
          ),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Hero(
                  tag: plants[index].name,
                  child: Image.asset(plants[index].bgImage),
                ),
              ),
            ),
          ),
        ),
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemCount: plants.length,
      ),
    );
  }
}
