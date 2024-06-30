import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:gardenapp/pages/home/widgets/explore.dart';
import 'package:gardenapp/pages/home/widgets/myPlants.dart';

class MenuSection extends StatelessWidget {
  MenuSection({super.key});
//avy amle valeur anle capteur
  final List<Map<String, dynamic>> statistics = const [
    {'title': 'Temp', 'value': 25, 'max': 50, 'unit': '°C'},
    {'title': 'Humidity', 'value': 80, 'max': 100, 'unit': '%'},
  ];

  static const TextStyle titleStyle = TextStyle(
    color: Color.fromARGB(255, 109, 109, 109),
    fontSize: 15,
  );

  static const TextStyle valueStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 25,
  );

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
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: statistics.map(_buildStatisticItem).toList(),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'My plants',
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'CaviarDreams',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              MyPlants(),
              const SizedBox(height: 10),
              const Text(
                'Explore',
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'CaviarDreams',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              NewestPlant(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticItem(Map<String, dynamic> statistic) {
    final double value = statistic['value'].toDouble();
    final double max = statistic['max'].toDouble();

    Color getColor(double value, double max) {
      if (value < max * 0.5) {
        return Colors.green;
      } else if (value < max * 0.75) {
        return Colors.yellow;
      } else if (value < max * 0.9) {
        return Colors.orange;
      } else {
        return Colors.red;
      }
    }

    return Container(
      width: 150,
      height: 150,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                statistic['title'],
                style: titleStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Expanded(
                child: SfRadialGauge(
                  enableLoadingAnimation: true, // Enable animations
                  animationDuration: 2000, // Duration of the animation
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
                          color: getColor(value, max),
                        ),
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                          widget: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$value ${statistic['unit']}',
                                style: valueStyle,
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
