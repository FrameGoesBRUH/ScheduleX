import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DayView(),
    );
  }
}
