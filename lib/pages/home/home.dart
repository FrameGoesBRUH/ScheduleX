//import 'dart:math';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:schedulex/local_notifications.dart';
import 'package:schedulex/pages/calendar/calendar.dart';
import 'package:schedulex/pages/model/event.dart';
import 'package:schedulex/pages/model/eventdata.dart';
import 'package:schedulex/provider/provider.dart';
import 'package:schedulex/size.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
//import 'package:schedulex/Theme/light_Theme.dart';
import '../mainComponents/drawer.dart';
import '../mainComponents/baseAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

bool alreadyload = false;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer _timer = Timer.periodic(const Duration(seconds: 1), (timer) {});

  bool isLoaded = false;
  //final user = FirebaseAuth.instance.currentUser!;
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  // final int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  List<dynamic> occurlist = [];
  List<dynamic> eventlist = [];
  List<dynamic> aceventlist = [];
  List<dynamic> idlist = [];
  var name = '';
  var email = '';
  var note = '';
  var more = '';
  TimeOfDay fromtime = const TimeOfDay(hour: 0, minute: 0);
  String totime = " - 00:00";

  //final events = Provider.of<EventProvider>(context).events;

  //List<dynamic> eventss = [];

  //Map<String, dynamic>
  //Future changeEvent() async {}

  void startCountdown(int duration) {
    if (alreadyload == false) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (duration <= 1) {
          timer.cancel();
          alreadyload = false;
          //dev.log(duration.toString());
          // Timer finished
          addEvent();
        } else {
          duration -= 1;
          alreadyload = true;
          //dev.log(duration.toString());
          //dev.log('snEnd');
        }
      });
    }
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
            builder: (context) => CalendarPage(
                  date: appointment.from,
                  //id: widget.id,
                )),
      );
    }
  }

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
        // dev.log(idlist[i]);
        var evnetref = await FirebaseFirestore.instance
            .collection("schedules")
            .doc(idlist[i])
            .get();
        eventlist = evnetref['events'];

        email = evnetref["owner"];
        if (eventlist.isNotEmpty) {
          for (var e = 0; e < eventlist.length; e++) {
            // dev.log(idlist[e]);
            var eventsssref = await FirebaseFirestore.instance
                .collection("events")
                .doc(eventlist[e])
                .get();
            Map<String, dynamic> scheduledataa = eventsssref.data()!;

            //dev.log(scheduledata["title"]);

            if (evnetref.exists) {
              //Map<String, dynamic> scheduledata = shareddoc.data()!;
              final event = Event(
                  title: scheduledataa["title"],
                  description: scheduledataa["description"],
                  from: scheduledataa["from"].toDate(),
                  to: scheduledataa["to"].toDate(),
                  backgroundColor: Color(scheduledataa["backgroundColor"]),
                  isAllDay: scheduledataa["isAllDay"],
                  recurrenceRule: scheduledataa["recurrenceRule"],
                  department: "development",
                  id: eventlist[i]);
              provider.addEvent(event);
              DateTime dateTime = scheduledataa["from"].toDate();
              DateTime dateTime2 = scheduledataa["to"].toDate();
              Duration differencetime = dateTime2.difference(dateTime);

              //DateTime dateTime2 = scheduledata["from"].toDate();
              List<DateTime> dateCollection =
                  SfCalendar.getRecurrenceDateTimeCollection(
                      scheduledataa["recurrenceRule"], dateTime);

              //dev.log(dateCollection.length.toString());
              if (dateCollection.isNotEmpty) {
                //dev.log(differencetime.toString());
                for (var i = 0; i < dateCollection.length; i++) {
                  //dev.log(dateCollection[i].toString());
                  aceventlist.add({
                    "name": scheduledataa["title"],
                    "description": scheduledataa["description"],
                    "email": evnetref["owner"],
                    "from": dateCollection[i],
                    "to": dateCollection[i].add(differencetime),
                  });
                }
              } else {
                aceventlist.add({
                  "name": scheduledataa["title"],
                  "description": scheduledataa["description"],
                  "email": evnetref["owner"],
                  "from": scheduledataa["from"].toDate(),
                  "to": scheduledataa["to"].toDate(),
                });
              }
            } else {
              setState(() {
                //dev.log('onEnd');
                fromtime = const TimeOfDay(hour: 0, minute: 0);
                totime = " - 00:00";
                email = "@dev";
                note = "-";

                name = "No Current Event";
                //exit = false;
              });
            }
          }
        } else {
          setState(() {
            //dev.log('onEnd');
            fromtime = const TimeOfDay(hour: 0, minute: 0);
            totime = " - 00:00";
            email = "@dev";
            note = "-";

            name = "No Current Event";
            //exit = false;
          });
        }
      }
      //dev.log(aceventlist.length.toString());
      for (var i = 0; i < aceventlist.length; i++) {
        Map<String, dynamic> scheduledata = aceventlist[i];
        ////dev.log(scheduledata.toString());
        DateTime to = scheduledata["to"];
        DateTime from = scheduledata["from"];
        if (to.isAfter(DateTime.now())) {
          if (from.isBefore(DateTime.now()) ||
              from.isAtSameMomentAs(DateTime.now())) {
            occurlist.add({scheduledata});
          }
        }
      }
      //dev.log(occurlist.length.toString());
      if (occurlist.isNotEmpty) {
        for (var i = 0; i < occurlist.length; i++) {
          Map<String, dynamic> scheduledata = aceventlist[i];
          //dev.log(scheduledata.toString());
          DateTime to = scheduledata["to"];
          DateTime from = scheduledata["from"];
          // dev.log(to.toString());

          //startCountdown();
          if (to.isAfter(DateTime.now())) {
            if (from.isBefore(DateTime.now()) ||
                from.isAtSameMomentAs(DateTime.now())) {
              if (occurlist.length != 1) {
                LocalNotifications.showSimpleNotification(
                    title: "You've got an Appointment",
                    body:
                        "You've got an appointment, ${scheduledata["name"]} and ${occurlist.length - 1} more from ${fromtime.hour.toString().padLeft(2, '0')}:${fromtime.minute.toString().padLeft(2, '0')}",
                    payload: "");
                setState(() {
                  more = " +${occurlist.length - 1} more";
                  totime =
                      " - ${to.hour.toString().padLeft(2, '0')}:${to.minute.toString().padLeft(2, '0')}";
                  note = ".  .  .";
                  name = scheduledata["name"];
                  email = scheduledata["email"];
                  fromtime = TimeOfDay(hour: from.hour, minute: from.minute);
                });
                startCountdown(((to.millisecondsSinceEpoch -
                            DateTime.now().millisecondsSinceEpoch) /
                        1000)
                    .ceil());
              } else {
                LocalNotifications.showSimpleNotification(
                    title: "You've got an Appointment",
                    body:
                        "You've got an appointment, ${scheduledata["name"]} from ${fromtime.hour.toString().padLeft(2, '0')}:${fromtime.minute.toString().padLeft(2, '0')}",
                    payload: "");
                startCountdown(((to.millisecondsSinceEpoch -
                            DateTime.now().millisecondsSinceEpoch) /
                        1000)
                    .ceil());
                setState(() {
                  name = scheduledata["name"];
                  email = scheduledata["email"];
                  note = scheduledata["description"];
                  fromtime = TimeOfDay(hour: from.hour, minute: from.minute);
                  more = "";
                  totime =
                      " - ${to.hour.toString().padLeft(2, '0')}:${to.minute.toString().padLeft(2, '0')}";
                });
              }
            } else if (from.isAfter(DateTime.now())) {
              //dev.log("Next : " + scheduledata["title"]);
              setState(() {
                name = "Next : ${scheduledata["name"]}";
                fromtime = TimeOfDay(hour: from.hour, minute: from.minute);
                totime =
                    " - ${to.hour.toString().padLeft(2, '0')}:${to.minute.toString().padLeft(2, '0')}";
                email = scheduledata["email"];
                note = scheduledata["description"];

                more = "";
                //dev.log('onEnd2');
                CountdownTimer(
                  endTime: from.millisecondsSinceEpoch,
                  onEnd: addEvent,
                );
              });
            }
          } else {
            setState(() {
              //dev.log('onEnd');
              fromtime = const TimeOfDay(hour: 0, minute: 0);
              totime =
                  " - ${to.hour.toString().padLeft(2, '0')}:${to.minute.toString().padLeft(2, '0')}";
              email = "@dev";
              note = "-";
              more = "";

              name = "No Current Event";
              //exit = false;
            });
          }
        }
      } else {
        setState(() {
          //dev.log('onEnd');
          fromtime = const TimeOfDay(hour: 0, minute: 0);
          totime = " - 00:00";
          email = "@dev";
          note = "-";
          more = "";

          name = "No Current Event";
          //exit = false;
        });
      }
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    addEvent();
    // sets first value
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: const baseAppBar(),
        drawer: const DrawerNav(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Container(
                      width: (MediaQuery.of(context).size.width),
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          GlowContainer(
                              //height:
                              color: Theme.of(context).colorScheme.secondary,
                              spreadRadius: 1,
                              blurRadius: 25,
                              glowColor: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withOpacity(.8),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 30, bottom: 15),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: isLoaded
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Flexible(
                                                    child: Text(name.toString(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: GoogleFonts.lato(
                                                          fontSize: 30,
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .inversePrimary,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        )),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Flexible(
                                                    child: Text(more.toString(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: GoogleFonts.lato(
                                                          fontSize: 18,
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .inversePrimary
                                                              .withOpacity(.8),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        )),
                                                  ),
                                                ]),
                                            const SizedBox(height: 4),
                                            Text(
                                                '${fromtime.hour.toString().padLeft(2, '0')}:${fromtime.minute.toString().padLeft(2, '0')}$totime',
                                                style: GoogleFonts.lato(
                                                  fontSize: 20,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .inversePrimary,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                            const SizedBox(height: 24),
                                            Text(email,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.lato(
                                                  fontSize: 15,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiary,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                            const SizedBox(height: 18),
                                            Divider(
                                              thickness: 1,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                            ),
                                            const SizedBox(height: 10),
                                            Text("Note",
                                                style: GoogleFonts.lato(
                                                  fontSize: 20,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiary,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                            const SizedBox(height: 4),
                                            Text(note,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.lato(
                                                  fontSize: 15,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .inversePrimary,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                            const SizedBox(height: 20),
                                          ],
                                        )
                                      : Center(
                                          child: Text("Loading",
                                              style: GoogleFonts.lato(
                                                fontSize: 20,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiary,
                                                fontWeight: FontWeight.w400,
                                              )),
                                        ),
                                ),
                              )),
                        ],
                      ))),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  "Task",
                  style: GoogleFonts.lato(
                    color: Theme.of(context).colorScheme.inverseSurface,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                  height: displayHeight(context) * 0.5,
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  child: SfCalendar(
                    view: CalendarView.schedule,
                    initialSelectedDate: DateTime.now(),
                    dataSource: EventDataSource(events),
                    onTap: calendarTapped,
                    showNavigationArrow: true,
                    scheduleViewSettings: ScheduleViewSettings(
                        monthHeaderSettings: MonthHeaderSettings(
                            monthFormat: 'MMMM, yyyy',
                            height: 100,
                            textAlign: TextAlign.left,
                            backgroundColor: Colors.transparent,
                            monthTextStyle: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface,
                                fontSize: 25,
                                fontWeight: FontWeight.w400))),
                  )),
            ],
          ),
        ));
  }
}
