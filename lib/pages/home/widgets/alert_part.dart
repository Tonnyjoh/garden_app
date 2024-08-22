import 'package:flutter/material.dart';
import '../../../models/alert.dart';
import 'alert_service.dart';

class AlertWidget extends StatelessWidget {
  final AlertService alertService;
  final int houseId;

  const AlertWidget({
    required this.alertService,
    required this.houseId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Alert>>(
      stream: alertService.getAlertsStream(houseId),
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

        final List<Alert> alerts = snapshot.data ?? [];

        if (alerts.isEmpty) {
          return Center(
            child: Text(
              "No alerts available.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Last Alerts",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              ...alerts.map((alert) => Container(
                margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: alert.severityColor,
                            ),
                          ),
                          if (alerts.indexOf(alert) != alerts.length - 1)
                            Expanded(
                              child: Container(
                                width: 2,
                                color: Colors.grey[300],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              alert.title,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: alert.severityColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              alert.description,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        alert.time,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        );
      },
    );
  }
}
