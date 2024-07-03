import 'package:flutter/material.dart';
import 'package:gardenapp/pages/home/widgets/expense_graph.dart';
import 'package:gardenapp/pages/home/widgets/expense_income.dart';
import 'package:gardenapp/pages/home/widgets/progress_chart.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    /*final screenHeight = MediaQuery.of(context).size.height;*/
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      backgroundColor: Colors.white,
      body: const SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            children: [
              Row(
                children:  [
                  ExpenseIncomeData(),
                ],
              ),
               SizedBox(height: 8),
              Padding(
                padding:EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Analytics",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height:300, // 40% of screen height
                      child: ExpenseGraphDesign(),
                    ),
                    SizedBox(
                      height: 120, // 20% of screen height
                      child: CircleProgressChart(),
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