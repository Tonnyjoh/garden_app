import 'package:flutter/material.dart';
import 'package:garden_app/models/plant.dart';

class ReviewSection extends StatelessWidget {
  final Plant plant;
  const ReviewSection(this.plant, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Ratings and review',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'view',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plant.score.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 48,
                ),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 25,
                        color: Colors.amber,
                      ),
                      const Icon(
                        Icons.star,
                        size: 25,
                        color: Colors.amber,
                      ),
                      const Icon(
                        Icons.star,
                        size: 25,
                        color: Colors.amber,
                      ),
                      const Icon(
                        Icons.star,
                        size: 25,
                        color: Colors.amber,
                      ),
                      Icon(Icons.star,
                          size: 25, color: Colors.grey.withOpacity(0.3)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${plant.review.toString()} review',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: double.maxFinite,
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xFF5F67EA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {},
              child: const Text(
                'Install',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
