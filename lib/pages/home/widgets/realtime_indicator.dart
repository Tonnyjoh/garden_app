import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class IndicatorWidget extends StatelessWidget {
  const IndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: Supabase.instance.client
          .from('realtime_indicators')
          .stream(primaryKey: ['id_realtime_indicator'])
          .asBroadcastStream(),
      initialData:const [],
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<Map<String, dynamic>> data = snapshot.data ?? [];

        // Transformation des données en statistiques pour SfRadialGauge
        final List<Map<String, dynamic>> statistics = [
          {
            'title': 'Temp',
            'value': data.isNotEmpty ? data[0]['temperature'] : 0,
            'max': 50,
            'unit': '°C',
            'image': 'assets/images/weather.png',
          },
          {
            'title': 'Humidity',
            'value': data.isNotEmpty ? data[0]['humidity'] : 0,
            'max': 100,
            'unit': '%',
            'image': 'assets/images/water-drop.png',
          },
        ];

        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: statistics
                .map((statistic) => _buildStatisticItem(statistic))
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildStatisticItem(Map<String, dynamic> statistic) {
    final double value = statistic['value'].toDouble();
    final double max = statistic['max'].toDouble();

    Color getColor(double value, double max, String title) {
      if (title == "Temp") {
        if (value < max * 0.5) {
          return Colors.green;
        } else if (value < max * 0.75) {
          return Colors.yellow;
        } else if (value < max * 0.9) {
          return Colors.orange;
        } else {
          return Colors.red;
        }
      } else {
        if (value < max * 0.5) {
          return Colors.red;
        } else if (value < max * 0.75) {
          return Colors.orange;
        } else if (value < max * 0.9) {
          return Colors.yellow;
        } else {
          return Colors.green;
        }
      }
    }

    return SizedBox(
      width: 170,
      height: 200,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                statistic['title'],
                style:const TextStyle(
                  color: Color.fromARGB(255, 109, 109, 109),
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Expanded(
                child: SfRadialGauge(
                  enableLoadingAnimation: true,
                  animationDuration: 2000,
                  axes: <RadialAxis>[
                    RadialAxis(
                      minimum: 0,
                      maximum: max,
                      showLabels: false,
                      showTicks: false,
                      axisLineStyle: const AxisLineStyle(
                        thickness: 0.2,
                        cornerStyle: CornerStyle.bothFlat,
                        color: Color.fromARGB(255, 214, 214, 214),
                        thicknessUnit: GaugeSizeUnit.factor,
                      ),
                      pointers: <GaugePointer>[
                        RangePointer(
                          value: value,
                          width: 0.2,
                          sizeUnit: GaugeSizeUnit.factor,
                          cornerStyle: CornerStyle.bothFlat,
                          color: getColor(value, max, statistic['title']),
                        ),
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                          widget: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                statistic['image'],
                                width: 40,
                                height: 40,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '$value ${statistic['unit']}',
                                style:const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          positionFactor: 0.1,
                          angle: 90,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
