import 'package:flutter/material.dart';

class Event {
  final String title;
  final String description;
  final DateTime from;
  final DateTime to;
  final Color backgroundColor;
  final bool isAllDay;
  final String recurrenceRule;
  final String? department;
  final String id;
  const Event({
    required this.title,
    required this.description,
    required this.from,
    required this.to,
    required this.backgroundColor,
    required this.isAllDay,
    required this.id,
    required this.recurrenceRule,
    required this.department,
  });
}
