import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/alert.dart';

class AlertService {
  final SupabaseClient client;

  AlertService({required this.client});

  Stream<List<Alert>> getAlertsStream(int houseId) {
    return client
        .from('alerts')
        .stream(primaryKey: ['id_alert'])
        .eq('id_house', houseId)
        .order('date', ascending: false)
        .map((response) {
     /* print("Raw data from Supabase: $response");*/

      final List<dynamic> data = response as List<dynamic>;

/*      if (data.isEmpty) {
        print("No alerts found.");
      } else {
        print("Data received: $data");
      }*/

      return data.map((alertData) {
       /* print("Processing alert data: $alertData");*/

        // Extract severity directly from alertData
        final severityId = alertData['id_type'] as int?;
        final severityName = _mapSeverityName(severityId);

       /* print("Alert type: $severityName, Mapped severity: $severityName");*/

        return Alert(
          title: alertData['message'] as String? ?? 'No title',
          description: alertData['message'] as String? ?? 'No description',
          time: _formatDate(alertData['date'] as String? ?? '1970-01-01T00:00:00Z'),
          severity: _mapSeverity(severityName),
        );
      }).toList();
    });
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final formatter = DateFormat('dd MMM yyyy, HH:mm');
    return formatter.format(date);
  }

  String _mapSeverityName(int? severityId) {
    switch (severityId) {
      case 1:
        return 'minor';
      case 2:
        return 'moderate';
      case 3:
        return 'critical';
      default:
        return 'unknown';
    }
  }

  Severity _mapSeverity(String severityName) {
    switch (severityName) {
      case 'critical':
        return Severity.critical;
      case 'moderate':
        return Severity.moderate;
      case 'minor':
        return Severity.minor;
      default:
        return Severity.minor;
    }
  }
}
