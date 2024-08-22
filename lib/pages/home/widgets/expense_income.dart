import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DailySummaryData extends StatefulWidget {
  const DailySummaryData({super.key});

  @override
  State<DailySummaryData> createState() => _DailySummaryDataState();
}

class _DailySummaryDataState extends State<DailySummaryData> {
  final List<String> itemList = ["Today", "This week", "This month"];
  String? selectedValue = "Today";
  String summaryText = 'Summary for Today';

  List<Map<String, dynamic>> indicatorData = [];

  double averageTemperature = 0.0;
  double averageHumidity = 0.0;
  double averageLight = 0.0;

  @override
  void initState() {
    super.initState();
    fetchIndicatorData();
  }

  Future<void> fetchIndicatorData() async {
    final response = await Supabase.instance.client
        .from('indicators')
        .select('*')
        .order('date_rel', ascending: false);

    if (response.isNotEmpty) {
      setState(() {
        indicatorData = List<Map<String, dynamic>>.from(response);
        calculateAverages();
      });
    } else {
      print('Error fetching data');
    }
  }

  void calculateAverages() {
    DateTime now = DateTime.now();
    List<Map<String, dynamic>> filteredData;

    switch (selectedValue) {
      case "Today":
        filteredData = indicatorData.where((data) {
          DateTime date = DateFormat("yyyy-MM-dd").parse(data["date_rel"]);
          return date.day == now.day && date.month == now.month && date.year == now.year;
        }).toList();
        summaryText = 'Summary for Today';
        break;
      case "This week":
        filteredData = indicatorData.where((data) {
          DateTime date = DateFormat("yyyy-MM-dd").parse(data["date_rel"]);
          DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          return date.isAfter(startOfWeek) || date.isAtSameMomentAs(startOfWeek);
        }).toList();
        summaryText = 'Summary for This Week';
        break;
      case "This month":
        filteredData = indicatorData.where((data) {
          DateTime date = DateFormat("yyyy-MM-dd").parse(data["date_rel"]);
          return date.month == now.month && date.year == now.year;
        }).toList();
        summaryText = 'Summary for This Month';
        break;
      default:
        filteredData = [];
        summaryText = 'Summary'; // Texte par défaut
    }

    /*print('Filtered Data: $filteredData');*/

    if (filteredData.isNotEmpty) {
      averageTemperature = filteredData
          .map((data) => data["air_temperature"])
          .reduce((a, b) => a + b) /
          filteredData.length;
      averageHumidity = filteredData
          .map((data) => data["air_humidity"])
          .reduce((a, b) => a + b) /
          filteredData.length;
      averageLight = filteredData
          .map((data) => data["sol_moisture"])
          .reduce((a, b) => a + b) /
          filteredData.length;
    } else {
      averageTemperature = 0.0;
      averageHumidity = 0.0;
      averageLight = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Expanded(
      child: SizedBox(
        height: screenHeight * 0.25,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Column(
            children: [
              Text(
                summaryText,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'CaviarDreams',
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: summaryContainer(
                      context,
                      Icons.thermostat,
                      "Air temp.",
                      averageTemperature,
                      const Color.fromRGBO(158, 235, 71, 1),
                      Colors.white,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: summaryContainer(
                      context,
                      Icons.water_drop,
                      "Air hum.",
                      averageHumidity,
                      Colors.white,
                      const Color.fromRGBO(158, 235, 71, 1),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: summaryContainer(
                      context,
                      Icons.water_drop,
                      "Soil moist.",
                      averageLight,
                      const Color.fromRGBO(255, 223, 71, 1),
                      Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                height: 35,
                width: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedValue,
                    dropdownColor: Colors.white,
                    items: itemList.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontFamily: 'CaviarDreams',
                            color: Color.fromARGB(255, 31, 30, 30),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue;
                        calculateAverages();
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget summaryContainer(BuildContext context, IconData icon, String text, double value, Color color, Color textColor) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              icon,
              color: textColor,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                ),
              ),
              Text(
                value.toStringAsFixed(1),
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
