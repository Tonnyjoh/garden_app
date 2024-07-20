import 'package:flutter/material.dart';
import 'package:gardenapp/pages/detail/detail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyPlants extends StatelessWidget {
  MyPlants({super.key});

  // Liste des plantes déjà plantées en utilisant un stream pour les données en temps réel
  final _plantsStream = Supabase.instance.client
      .from('plants')
      .stream(primaryKey: ['id_plant'])
      .eq('id_house', 2)
      .order('id_plant', ascending: true);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _plantsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final List<dynamic> plantsData = snapshot.data as List<dynamic>? ?? [];

          if (plantsData.isEmpty) {
            return const Center(
              child: Text(
                'No plants found. Add a plant to get started!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return SizedBox(
            height: 200,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 20,
              ),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  print(plantsData[index]);
                  Navigator.of(context).push(
                    MaterialPageRoute(

                      builder: (context) => DetailPage(plantsData[index]['id_plant']),
                    ),
                  );
                },
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
                        tag: plantsData[index]['name'],
                        child: Image.asset(plantsData[index]['bg_image']),
                      ),
                    ),
                  ),
                ),
              ),
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemCount: plantsData.length,
            ),
          );
        }
      },
    );
  }
}
