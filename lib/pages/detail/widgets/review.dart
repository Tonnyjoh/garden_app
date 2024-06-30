import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gardenapp/models/plant.dart';

class ReviewSection extends StatelessWidget {
  final Plant plant;
  const ReviewSection(this.plant, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int filledDrops =
        (plant.waterNeed / 2).round(); // Assuming waterNeed is out of 10
    int totalDrops = 5;

    int filledTemps = (plant.temperatureNeed / 10)
        .round(); // Assuming temperatureNeed is out of 50
    int totalTemps = 5;

    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Needs',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(totalDrops, (index) {
                      return Icon(
                        Icons.water_drop_outlined,
                        color: index < filledDrops ? Colors.blue : Colors.grey,
                        size: 20,
                      );
                    }),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Water',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(totalTemps, (index) {
                      return Icon(
                        CupertinoIcons.thermometer,
                        color:
                            index < filledTemps ? Colors.orange : Colors.grey,
                        size: 20,
                      );
                    }),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Temp',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Notifications',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: plant.notifications.map((notification) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.notifications,
                        color: Colors.green,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        notification,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
