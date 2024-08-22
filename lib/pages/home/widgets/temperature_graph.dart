import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TemperatureGraph extends StatefulWidget {
  const TemperatureGraph({super.key});

  @override
  State<TemperatureGraph> createState() => _TemperatureGraphState();
}

class _TemperatureGraphState extends State<TemperatureGraph> {
  late Future<List<FlSpot>> _temperatureDataFuture;

  @override
  void initState() {
    super.initState();
    _temperatureDataFuture = _fetchTemperatureData();
  }

  Future<List<FlSpot>> _fetchTemperatureData() async {
    try {
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 6));

      final response = await Supabase.instance.client
          .from('indicators')
          .select()
          .gte('date_rel', startOfWeek.toIso8601String())
          .lte('date_rel', endOfWeek.toIso8601String())
          .order('date_rel', ascending: true);

      final data = response as List<dynamic>;

      // Créez une liste avec 7 jours (pour chaque jour de la semaine)
      final List<FlSpot> temperatureData = List.generate(7, (index) => FlSpot(index.toDouble(), 0.0));

      for (var item in data) {
        final temperature = (item['air_temperature'] as num).toDouble();
        final date = DateTime.parse(item['date_rel']);
        final dayOfWeek = date.weekday - 1; // Convertir le jour de la semaine (1 = lundi, 7 = dimanche)

        // Assurez-vous que la température est bien ajoutée à la bonne position du graphique
        temperatureData[dayOfWeek] = FlSpot(dayOfWeek.toDouble(), temperature);
      }

      return temperatureData;
    } catch (e) {
      print('Erreur de récupération des données : $e');
      return List.generate(7, (index) => FlSpot(index.toDouble(), 0.0)); // Valeurs par défaut en cas d'erreur
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FlSpot>>(
      future: _temperatureDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Aucune donnée disponible'));
        }

        final temperatureData = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(bottom: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 6,
                  minY: 5,
                  maxY: 35,
                  lineBarsData: [
                    LineChartBarData(
                      spots: temperatureData,
                      isCurved: true,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFF8A80),
                          Color(0xFFC62828),
                        ],
                      ),
                      barWidth: 4,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFFF8A80).withOpacity(0.3),
                            const Color(0xFFC62828).withOpacity(0.3),
                          ],
                        ),
                      ),
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: Colors.red,
                          );
                        },
                      ),
                    ),
                  ],
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    horizontalInterval: 2,
                    drawVerticalLine: true,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade300,
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade300,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text('Mon', style: TextStyle(color: Colors.black, fontSize: 12));
                            case 1:
                              return const Text('Tue', style: TextStyle(color: Colors.black, fontSize: 12));
                            case 2:
                              return const Text('Wed', style: TextStyle(color: Colors.black, fontSize: 12));
                            case 3:
                              return const Text('Thr', style: TextStyle(color: Colors.black, fontSize: 12));
                            case 4:
                              return const Text('Fri', style: TextStyle(color: Colors.black, fontSize: 12));
                            case 5:
                              return const Text('Sat', style: TextStyle(color: Colors.black, fontSize: 12));
                            case 6:
                              return const Text('Sun', style: TextStyle(color: Colors.black, fontSize: 12));
                            default:
                              return Container();
                          }
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                ),
              ),
            ),
            const Text(
              'Temperature (°C) for the week',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        );
      },
    );
  }
}
