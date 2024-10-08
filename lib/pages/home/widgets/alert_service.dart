import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gardenapp/models/alert.dart';

class AlertService {
  final SupabaseClient client;
  final String? userEmail;
  AlertService({required this.client, this.userEmail});

  Stream<List<Alert>> getAlertsStream(int houseId) {
    return client
        .from('alerts')
        .stream(primaryKey: ['id_alert'])
        .eq('id_house', houseId)
        .order('date', ascending: false)
        .map((response) {
      final List<dynamic> data = response as List<dynamic>;

      final alerts = data.map((alertData) {
        final severityId = alertData['id_type'] as int?;
        final severityName = _mapSeverityName(severityId);

        return Alert(
          title: alertData['message'] as String? ?? 'No title',
          description: alertData['message'] as String? ?? 'No description',
          time: _formatDate(alertData['date'] as String? ?? '1970-01-01T00:00:00Z'),
          severity: _mapSeverity(severityName),
          id: alertData['id_alert'] as int,
          emailSent: alertData['email_sent'] as bool? ?? false,
        );
      }).toList();

      if (alerts.isNotEmpty) {
        final latestAlert = alerts.first;
        _sendAlertEmail(latestAlert);
      }
      return alerts;
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

  void _sendAlertEmail(Alert alert) async {
    // Vérifier si l'email a déjà été envoyé pour cette alerte
    if (alert.emailSent) {
      print('Email already sent for this alert. No email sent.');
      return;
    }

    await dotenv.load();
    final username = dotenv.env['MAIL'];
    final password = dotenv.env['PASSWORD'];

    if (username == null || password == null) {
      print('Error: Missing environment variables for email or password.');
      return;
    }

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Garden App')
      ..recipients.add(userEmail)
      ..subject = 'New Alert: ${alert.severity} - ${alert.title} - ${DateTime.now()}'
      ..text = 'You have a new alert:\n\n'
          'Title: ${alert.title}\n'
          'Description: ${alert.description}\n'
          'Time: ${alert.time}\n'
          'Severity: ${alert.severity.toString().split('.').last}\n';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: $sendReport');

      await client
          .from('alerts')
          .update({'email_sent': true})
          .eq('id_alert', alert.id);
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
  }
}