import 'package:flutter/material.dart';
import 'temperature_graph.dart';
import 'humidity_graph.dart';

class GraphPageView extends StatelessWidget {
  const GraphPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: const [
        TemperatureGraph(), // Page 1: Temperature
        HumidityGraph(),    // Page 2: Humidity
      ],
    );
  }
}
