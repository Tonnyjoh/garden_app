import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:garden_app/models/plant.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example data: weekly temperature and humidity
    final List<double> temperatureData = [24, 25, 28, 30, 27, 26, 29];
    final List<double> humidityData = [60, 55, 50, 65, 70, 68, 62];

    // Example plant evolution data
    final List<PlantEvolution> plantEvolution = [
      PlantEvolution(day: 'Mon', stage: PlantStage.Growing),
      PlantEvolution(day: 'Tue', stage: PlantStage.Blooming),
      PlantEvolution(day: 'Wed', stage: PlantStage.Blooming),
      PlantEvolution(day: 'Thu', stage: PlantStage.Fruiting),
      PlantEvolution(day: 'Fri', stage: PlantStage.Fruiting),
      PlantEvolution(day: 'Sat', stage: PlantStage.Harvesting),
      PlantEvolution(day: 'Sun', stage: PlantStage.Harvesting),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Text(
            'Temperature and Humidity',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          AspectRatio(
            aspectRatio: 1.5,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: SideTitles(
                    showTitles: true,
                    getTitles: (double value) {
                      switch (value.toInt()) {
                        case 0:
                          return 'Mon';
                        case 1:
                          return 'Tue';
                        case 2:
                          return 'Wed';
                        case 3:
                          return 'Thu';
                        case 4:
                          return 'Fri';
                        case 5:
                          return 'Sat';
                        case 6:
                          return 'Sun';
                        default:
                          return '';
                      }
                    },
                  ),
                  leftTitles: SideTitles(showTitles: true),
                ),
                borderData: FlBorderData(
                    show: true, border: Border.all(color: Colors.black)),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                          y: temperatureData[0], colors: [Colors.blue])
                    ],
                    showingTooltipIndicators: [0],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                          y: temperatureData[1], colors: [Colors.blue])
                    ],
                    showingTooltipIndicators: [0],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(
                          y: temperatureData[2], colors: [Colors.blue])
                    ],
                    showingTooltipIndicators: [0],
                  ),
                  BarChartGroupData(
                    x: 3,
                    barRods: [
                      BarChartRodData(
                          y: temperatureData[3], colors: [Colors.blue])
                    ],
                    showingTooltipIndicators: [0],
                  ),
                  BarChartGroupData(
                    x: 4,
                    barRods: [
                      BarChartRodData(
                          y: temperatureData[4], colors: [Colors.blue])
                    ],
                    showingTooltipIndicators: [0],
                  ),
                  BarChartGroupData(
                    x: 5,
                    barRods: [
                      BarChartRodData(
                          y: temperatureData[5], colors: [Colors.blue])
                    ],
                    showingTooltipIndicators: [0],
                  ),
                  BarChartGroupData(
                    x: 6,
                    barRods: [
                      BarChartRodData(
                          y: temperatureData[6], colors: [Colors.blue])
                    ],
                    showingTooltipIndicators: [0],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Plant Evolution',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: plantEvolution.length,
            itemBuilder: (context, index) {
              final evolution = plantEvolution[index];
              return ListTile(
                leading: Icon(
                  FontAwesomeIcons.seedling,
                  color: Colors.green,
                ),
                title: Text('${evolution.day}: ${evolution.stage}'),
              );
            },
          ),
        ],
      ),
    );
  }
}

enum PlantStage {
  Growing,
  Blooming,
  Fruiting,
  Harvesting,
}

class PlantEvolution {
  final String day;
  final PlantStage stage;

  PlantEvolution({required this.day, required this.stage});
}
