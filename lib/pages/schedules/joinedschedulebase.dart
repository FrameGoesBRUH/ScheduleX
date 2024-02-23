import 'package:flutter/material.dart';
import 'package:schedulex/pages/schedules/components/members.dart';
import 'package:schedulex/pages/schedules/viewevent.dart';
import 'package:schedulex/provider/provider.dart';
import 'package:schedulex/size.dart';
import '../mainComponents/drawer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../model/eventdata.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/event.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'dart:developer' as dev;

class JoinedSchedule extends StatefulWidget {
  final String id;
  final String name;

  const JoinedSchedule({super.key, required this.id, required this.name});

  @override
  State<JoinedSchedule> createState() => _JoinedScheduleState(name);
}

class _JoinedScheduleState extends State<JoinedSchedule> {
  final String name;

  List<dynamic> eventlist = [];
  List<dynamic> member = [];
  List<dynamic> memberemail = [];
  List<dynamic> contributor = [];

  _JoinedScheduleState(this.name);
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    final Event appointmentDetails = calendarTapDetails.appointments![0];
    //developer.log(appointmentDetails.id.toString());
    if (calendarTapDetails.targetElement == CalendarElement.appointment) {
      //developer.log(calendarTapDetails.appointments![0]);
      //final event = eve
      Event appointment = Event(
          title: appointmentDetails.title,
          description: appointmentDetails.description,
          from: appointmentDetails.from,
          to: appointmentDetails.to,
          backgroundColor: appointmentDetails.backgroundColor,
          isAllDay: appointmentDetails.isAllDay,
          recurrenceRule: appointmentDetails.recurrenceRule,
          department: "development",
          id: appointmentDetails.id);

      //appointment.recurrenceRule = "";
      //developer.log(appointmentDetails.id.toString());
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewEvent(
                  appointment: appointment,
                )),
      );
    }
  }

  Future addEvent() async {
    final evnetref = await FirebaseFirestore.instance
        .collection("schedules")
        .doc(widget.id)
        .get();

    Map<String, dynamic> shareddata = evnetref.data()!;
    member = evnetref['member'];
    //developer.log(member[1]);

    contributor = shareddata['contributor'];

    if (member.isEmpty) {
      member.add("-");
    }
    if (contributor.isEmpty) {
      contributor.add("-");
    }

    eventlist = evnetref['events'];
    final provider = Provider.of<EventProvider>(context, listen: false);
    provider.clearEvent();
    //dev.log(eventlist.length.toString());
    if (eventlist.isNotEmpty) {
      for (var i = 0; i < eventlist.length; i++) {
        //developer.log(eventlist.length.toString());
        //developer.log(eventlist[i].toString());
        //int id = eventlist.length - 1;
        final scheduledata = await FirebaseFirestore.instance
            .collection("events")
            .doc(eventlist[i])
            .get();
        if (evnetref.exists) {
          //developer.log(scheduledata.toString());
          final event = Event(
            title: scheduledata["title"],
            description: scheduledata["description"],
            from: scheduledata["from"].toDate(),
            to: scheduledata["to"].toDate(),
            backgroundColor: Color(scheduledata["backgroundColor"]),
            isAllDay: scheduledata["isAllDay"],
            recurrenceRule: scheduledata["recurrenceRule"],
            id: scheduledata["id"],
            department: "development",
          );

          provider.addEvent(event);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    addEvent();
  }

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
              bottom: TabBar(
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: Theme.of(context).colorScheme.primary,
                tabs: [
                  Tab(
                      icon: Icon(Icons.calendar_month_rounded,
                          color: Theme.of(context).colorScheme.inverseSurface)),
                  Tab(
                      icon: Icon(Icons.people,
                          color: Theme.of(context).colorScheme.inverseSurface)),
                ],
              ),
              title: Text(name),
              iconTheme: IconThemeData(
                  color: Theme.of(context).colorScheme.inverseSurface),
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.background,
              actions: [
                IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.mail,
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                ),
              ]),
          drawer: const DrawerNav(),
          body: TabBarView(children: [
            Container(
                height: displayHeight(context) * 0.7,
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: SfCalendar(
                  view: CalendarView.schedule,
                  initialSelectedDate: DateTime.now(),
                  dataSource: EventDataSource(events),
                  showNavigationArrow: true,
                  onTap: calendarTapped,
                  scheduleViewSettings: ScheduleViewSettings(
                      monthHeaderSettings: MonthHeaderSettings(
                          monthFormat: 'MMMM, yyyy',
                          height: 100,
                          textAlign: TextAlign.left,
                          backgroundColor: Colors.transparent,
                          monthTextStyle: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inverseSurface,
                              fontSize: 25,
                              fontWeight: FontWeight.w400))),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Contributors",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inverseSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Flexible(
                    child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: contributor.length,
                  itemBuilder: (context, index) => Container(
                      padding: const EdgeInsets.all(10),
                      child: MemberButton(
                        text: contributor[index]["email"],
                        uid: contributor[index]["uid"],
                      )),
                )),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Members",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inverseSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                Flexible(
                    child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: member.length,
                  itemBuilder: (context, index) => Container(
                      padding: const EdgeInsets.all(10),
                      child: MemberButton(
                        text: member[index]["email"],
                        uid: member[index]["uid"],
                      )),
                )),
              ]),
            ),
          ]),
        ));
  }
}
