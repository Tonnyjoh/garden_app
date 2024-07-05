import 'package:flutter/material.dart';
import 'package:gardenapp/models/plant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewestPlant extends StatelessWidget {
  NewestPlant({super.key});

  final _plants = Supabase.instance.client
      .from('plants')
      .select();

  // Récupération de la liste des pays depuis Supabase
  final _future = Supabase.instance.client
      .from('countries')
      .select();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          _buildPlantsSection(context), // Passer le contexte ici
          const SizedBox(height: 20),
          _buildCountriesSection(context), // Passer le contexte ici
        ],
      ),
    );
  }

  Widget _buildPlantsSection(BuildContext context) {
    return FutureBuilder(
      future: _plants,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final List<dynamic> plantsData = snapshot.data as List<dynamic>;

          return Column(
            children: plantsData
                .map(
                  (plant) => Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                    clipBehavior: Clip.none, // Permet au contenu de dépasser
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.asset(
                              plant['icon'],
                              width: 60,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  plant['name'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  plant['variety'],
                                  style: TextStyle(
                                    color: Colors.grey.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: -20,
                        right: -20,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                          child: IconButton(
                            onPressed: () {
                              print('Button pressed!'); // Vérifiez que ce message s'affiche
                              _showCustomSnackBar(context, 'New plant added!'); // Passer le contexte ici
                            },
                            icon: const Icon(Icons.add),
                            color: Colors.white,
                            iconSize: 30,
                          ),
                        ),
                      ),
                    ],
                  ),),
            )
                .toList(),
          );
        }
      },
    );


  }

  Widget _buildCountriesSection(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final List<dynamic> countriesData = snapshot.data as List<dynamic>;

          return Column(
            children: countriesData
                .map(
                  (country) => GestureDetector(
                onTap: () {
                  _showCustomSnackBar(context, 'Country ID: ${country['id']}'); // Afficher l'ID du pays
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        country['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
                .toList(),
          );
        }
      },
    );
  }

  void _showCustomSnackBar(BuildContext context, String message) {
    final overlay = Overlay.of(context)!; // Utiliser ! pour indiquer que context ne peut pas être null à ce stade
    final snackBar = OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const Icon(Icons.check, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(snackBar);
    Future.delayed(const Duration(seconds: 3), () {
      snackBar.remove();
    });
  }
}
