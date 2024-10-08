import 'package:flutter/material.dart';

enum Severity { critical, moderate, minor }

class Alert {
  final String title;

  final String description;

  final String time;

  final Severity severity;

  final bool emailSent;
  final int id;
  Alert({
    required this.title,
    required this.description,
    required this.time,
    required this.emailSent,
    required this.id,
    this.severity = Severity.minor,
  });

  Color get severityColor {
    switch (severity) {
      case Severity.minor:
        return Colors.teal;
      case Severity.moderate:
        return Colors.orange;
      case Severity.critical:
        return Colors.red;
    }
  }
}
