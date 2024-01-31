import 'package:flutter/material.dart';
import 'package:schedulex/pages/schedules/eventedit.dart';
import 'package:schedulex/provider/provider.dart';
import 'package:schedulex/size.dart';
import '../mainComponents/baseAppBar.dart';
import '../mainComponents/drawer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/eventdata.dart';
import '../../provider/provider.dart';
import 'package:provider/provider.dart';

class SharedSchedule extends StatefulWidget {
  final String id;
  final String name;

  SharedSchedule({super.key, required this.id, required this.name});

  @override
  State<SharedSchedule> createState() => _SharedScheduleState(name);
}

class _SharedScheduleState extends State<SharedSchedule> {
  final String name;

  _SharedScheduleState(this.name);
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const baseAppBar(),
      drawer: const DrawerNav(),
      body: Column(children: [
        Container(
          margin: EdgeInsets.all(10),
          child: Text(name,
              style: GoogleFonts.lato(
                fontSize: 30,
                color: Theme.of(context).colorScheme.inversePrimary,
                //fontWeight: FontWeight.w600,
              )),
        ),
        Container(
          height: displayHeight(context) * 0.7,
          margin: EdgeInsets.symmetric(horizontal: 25),
          child: SfCalendar(
            view: CalendarView.week,
            initialSelectedDate: DateTime.now(),
            dataSource: EventDataSource(events),
            showNavigationArrow: true,
          ),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.plus_one,
          color: Theme.of(context).colorScheme.inverseSurface,
        ),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const EventEdit(
                  event: null,
                ))),
      ),
    );
  }
}
