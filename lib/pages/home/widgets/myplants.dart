import 'package:flutter/material.dart';
import 'package:gardenapp/pages/detail/detail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyPlants extends StatelessWidget {
  MyPlants({super.key});

  final _plantsStream = Supabase.instance.client
      .from('plants')
      .stream(primaryKey: ['id_plant'])
      .eq('id_house', 2);

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

          final plant = plantsData.first;

          return Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              /*width: MediaQuery.of(context).size.width * 0.9,*/
              width: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.white.withOpacity(0.9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Hero(
                      tag: plant['name'],
                      child: Image.asset(
                        plant['bg_image'],
                        fit: BoxFit.cover,
                        width: 150,
                        height: 150,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  const SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 32,

                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, color: Colors.green, size: 16),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DetailPage(plant['id_plant']),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String status, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blue),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          const Spacer(),
          /*Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              status,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}
