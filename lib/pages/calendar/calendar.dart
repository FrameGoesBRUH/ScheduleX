import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:schedulex/pages/mainComponents/drawer.dart';
import '../mainComponents/baseAppBar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const baseAppBar(),
      drawer: const DrawerNav(),
      body: Scaffold(
          body: SfCalendar(
        view: CalendarView.day,
        showNavigationArrow: true,
      )),
    );
  }
}
