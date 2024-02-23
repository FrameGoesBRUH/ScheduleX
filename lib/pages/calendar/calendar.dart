import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedulex/pages/model/event.dart';
import 'package:schedulex/pages/model/eventdata.dart';
import 'package:schedulex/provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:schedulex/pages/mainComponents/drawer.dart';
import '../mainComponents/baseAppBar.dart';

class CalendarPage extends StatefulWidget {
  final DateTime date;

  const CalendarPage({super.key, required this.date});
  //const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  bool isLoaded = false;
  List<dynamic> idlist = [];
  List<dynamic> eventlist = [];
  List<String> email = [];

  Future addEvent() async {
    isLoaded = false;
    var userdoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    //dev.log("sdsd");

    if (userdoc.exists) {
      Map<String, dynamic> userdata = userdoc.data()!;

      //log("message");
      final provider = Provider.of<EventProvider>(context, listen: false);

      idlist = userdata['joined'];

      ////log(friendsList.toString());
      //friendsList = (value.data() as dynamic)["friends"];

      for (var i = 0; i < idlist.length; i++) {
        //dev.log(idlist[i]);
        var evnetref = await FirebaseFirestore.instance
            .collection("schedules")
            .doc(idlist[i])
            .get();
        eventlist = evnetref['events'];

        email = evnetref["owner"];
        if (eventlist.isNotEmpty) {
          for (var e = 0; e < eventlist.length; e++) {
            //dev.log(idlist[e]);
            var eventsssref = await FirebaseFirestore.instance
                .collection("events")
                .doc(eventlist[e])
                .get();
            Map<String, dynamic> scheduledata = eventsssref.data()!;

            //dev.log(scheduledata["title"]);
            final event = Event(
                title: scheduledata["title"],
                description: scheduledata["description"],
                from: scheduledata["from"].toDate(),
                to: scheduledata["to"].toDate(),
                backgroundColor: Color(scheduledata["backgroundColor"]),
                isAllDay: scheduledata["isAllDay"],
                recurrenceRule: scheduledata["recurrenceRule"],
                department: "development",
                id: eventlist[i]);
            provider.addEvent(event);
          }
        }
      }
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: const baseAppBar(),
        drawer: const DrawerNav(),
        body: SfCalendar(
          view: CalendarView.schedule,
          initialSelectedDate: widget.date,
          dataSource: EventDataSource(events),
          onTap: null,
          showNavigationArrow: true,
          scheduleViewSettings: ScheduleViewSettings(
              monthHeaderSettings: MonthHeaderSettings(
                  monthFormat: 'MMMM, yyyy',
                  height: 100,
                  textAlign: TextAlign.left,
                  backgroundColor: Colors.transparent,
                  monthTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.inverseSurface,
                      fontSize: 25,
                      fontWeight: FontWeight.w400))),
        ));
  }
}
