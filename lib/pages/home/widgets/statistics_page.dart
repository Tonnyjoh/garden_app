import 'package:flutter/material.dart';
import 'package:gardenapp/pages/home/user_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gardenapp/pages/home/widgets/alert_part.dart';
import 'package:gardenapp/pages/home/widgets/expense_graph.dart';
import 'package:gardenapp/pages/home/widgets/expense_income.dart';
import 'package:provider/provider.dart';
import 'alert_service.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SupabaseClient client = Supabase.instance.client;
    final userProvider = Provider.of<UserProvider>(context);
    final userEmail = userProvider.email;
    final AlertService alertService = AlertService(client: client, userEmail: userEmail);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            children: [
              const Row(
                children: [
                  DailySummaryData(),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Analytics",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'CaviarDreams',
                      ),
                    ),
                    const SizedBox(
                      height: 320, // 40% of screen height
                      child: GraphPageView(),
                    ),
                    SizedBox(
                      height: 260, // 20% of screen height
                      child: AlertWidget(
                        alertService: alertService,
                        houseId: 2,
                      ),
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
