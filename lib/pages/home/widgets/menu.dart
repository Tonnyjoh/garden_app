import 'package:flutter/material.dart';
// import 'package:test_drive/pages/home/widgets/newest.dart';
import 'package:test_drive/pages/home/widgets/popular.dart';

class MenuSection extends StatelessWidget {
  MenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF6F8FF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Column(
            children: [
              //ici la statistique
              ElevatedButton(
                onPressed: () {
                  print('button pressed! ');
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            width: 410,
            child: const Text(
              'Popular plant',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          PopularPlant(),
        ],
      ),
    );
  }
}
