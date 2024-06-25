import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schedulex/pages/schedules/components/membersedit.dart';
import 'package:schedulex/pages/schedules/eventedit.dart';
import 'package:schedulex/pages/schedules/invite.dart';
import 'package:schedulex/pages/schedules/sharedlist.dart';
import 'package:schedulex/pages/schedules/updateevent.dart';
import 'package:schedulex/pages/schedules/viewevent.dart';
import 'package:schedulex/provider/provider.dart';
import 'package:schedulex/size.dart';
import '../mainComponents/drawer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../model/eventdata.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/event.dart';
import 'dart:developer' as developer;
import 'package:firebase_auth/firebase_auth.dart';

const List<Widget> schedule = <Widget>[
  Text('Schedule'),
  Text('Day'),
  Text('Week'),
  Text('Month'),
];

class SharedSchedule extends StatefulWidget {
  final String id;
  final String name;
  final String name2;

  const SharedSchedule(
      {super.key, required this.id, required this.name, required this.name2});

  @override
  State<SharedSchedule> createState() => _SharedScheduleState();
}

class _SharedScheduleState extends State<SharedSchedule>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final nameController = TextEditingController();

  bool isLoaded = false;

  var nameerror;

  final List<bool> isSelected = <bool>[true, false, false, false];

  bool personal = false;

  bool canedit = false;
  bool caninvite = false;

  bool canpermission = false;
  bool candelete = false;
  bool checkcanedit = false;
  bool checkcaninvite = false;

  bool checkcanpermission = false;
  bool checkcandelete = false;

  List<dynamic> eventlist = [];
  List<dynamic> member = [];
  //List<dynamic> memberemail = [];
  List<dynamic> contributor = [];

  bool isowner = false;

  //_SharedScheduleState(this.name);
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  Future isOwner() async {
    final scheduleref =
        FirebaseFirestore.instance.collection("schedules").doc(widget.id);
    isowner = false;
  }

  Future deleteschedule() async {
    checksetting();
    if (isowner == true || candelete == true) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const SharedList()));

      var userdoc = FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid);

      userdoc.update({
        "shared": FieldValue.arrayRemove([widget.id])
      });

      for (var i = 0; i < member.length; i++) {
        var docc = FirebaseFirestore.instance
            .collection("users")
            .doc(member[i]["uid"]);

        docc.update({
          "joined": FieldValue.arrayRemove([widget.id])
        });
      }

      for (var i = 0; i < contributor.length; i++) {
        var docc = FirebaseFirestore.instance
            .collection("users")
            .doc(contributor[i]["uid"]);

        docc.update({
          "shared": FieldValue.arrayRemove([widget.id])
        });
      }
      await FirebaseFirestore.instance
          .collection("schedules")
          .doc(widget.id)
          .delete();
    } else {
      Navigator.pop(context);
      shownormaldialog(context, "No Permission");
    }
  }

  Future clearschedule() async {
    checksetting();
    if (isowner == true || candelete == true) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const SharedList()));

      var userdoc = FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid);

      userdoc.update({
        "shared": FieldValue.arrayRemove([widget.id])
      });

      for (var i = 0; i < member.length; i++) {
        var docc = FirebaseFirestore.instance
            .collection("users")
            .doc(member[i]["uid"]);

        docc.update({
          "joined": FieldValue.arrayRemove([widget.id])
        });
      }

      for (var i = 0; i < contributor.length; i++) {
        var docc = FirebaseFirestore.instance
            .collection("users")
            .doc(contributor[i]["uid"]);

        docc.update({
          "shared": FieldValue.arrayRemove([widget.id])
        });
      }
      await FirebaseFirestore.instance
          .collection("schedules")
          .doc(widget.id)
          .delete();
    } else {
      Navigator.pop(context);
      shownormaldialog(context, "No Permission");
    }
  }

  Future setting() async {
    checksetting();
    if (isowner == true || checkcanpermission == true) {
      FirebaseFirestore.instance.collection("schedules").doc(widget.id).update({
        "permission": {
          "canedit": canedit,
          "caninvite": caninvite,
          "canpermission": canpermission,
          "candelete": candelete
        }
      });
    } else {
      final evnetref = await FirebaseFirestore.instance
          .collection("schedules")
          .doc(widget.id)
          .get();

      Map<String, dynamic> permissiondata = evnetref["permission"];

      shownormaldialog(
        context,
        "No Permission",
      );
      canedit = permissiondata["canedit"];
      caninvite = permissiondata["caninvite"];
      canpermission = permissiondata["canpermission"];
      candelete = permissiondata["candelete"];
    }
  }

  Future returnname() async {
    final evnetref = await FirebaseFirestore.instance
        .collection("schedules")
        .doc(widget.id)
        .get();
    setState(() {
      nameController.text = evnetref["name"];
    });
  }

  Future changeName() async {
    checksetting();
    // developer.log("w2a");

    if (isowner == true || checkcanpermission == true) {
      // developer.log("wa");
      if (nameController.text.trim() != "") {
        FirebaseFirestore.instance
            .collection("schedules")
            .doc(widget.id)
            .update({"name": nameController.text});
      } else {
        returnname();
      }
    } else {
      //Navigator.pop(context);
      shownormaldialog(
        context,
        "No Permission",
      );
    }
  }

  Future<void> showdialog(BuildContext context, String text1, String text2,
      Function() onpressed, Function() onpress2) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(text1),
                  Text(text2),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(onPressed: onpress2, child: const Text('Cancel')),
              TextButton(onPressed: onpressed, child: const Text('Confirm')),
            ],
          );
        });
  }

  Future<void> deleteMember(String uid, String email, int type) async {
    checksetting();
    var userdoc = FirebaseFirestore.instance.collection("users").doc(uid);
    if (isowner == true || checkcaninvite == true) {
      if (type == 1) {
        FirebaseFirestore.instance
            .collection("schedules")
            .doc(widget.id)
            .update({
          'member': FieldValue.arrayRemove([
            {"email": email, "uid": uid}
          ])
        });
        userdoc.update({
          'joined': FieldValue.arrayRemove([widget.id])
        });
        setState(() {
          member.remove([
            {"email": email, "uid": uid}
          ]);
        });
      } else {
        FirebaseFirestore.instance
            .collection("schedules")
            .doc(widget.id)
            .update({
          'contributor': FieldValue.arrayRemove([
            {"email": email, "uid": uid}
          ])
        });
        userdoc.update({
          'shared': FieldValue.arrayRemove([widget.id])
        });
        contributor.remove([
          {"email": email, "uid": uid}
        ]);
      }
    } else {
      Navigator.pop(context);
      shownormaldialog(
        context,
        "No Permission",
      );
    }
  }

  Future checksetting() async {
    final evnetref = await FirebaseFirestore.instance
        .collection("schedules")
        .doc(widget.id)
        .get();
    Map<String, dynamic> permissiondata = evnetref["permission"];
    setState(() {
      checkcanedit = permissiondata["canedit"];
      checkcaninvite = permissiondata["caninvite"];
      checkcandelete = permissiondata["candelete"];
      checkcanpermission = permissiondata["canpermission"];
    });
  }

  Future<void> shownormaldialog(BuildContext context, String title) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('You dont have the permission!'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future addevent2() async {
    checksetting();
    developer.log(checkcanedit.toString());
    if (isowner == true || checkcanedit == true) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EventEdit(
                id: widget.id,
                event: null,
              )));
    } else {
      shownormaldialog(context, "No Permission!");
    }
  }

  Future addEvent() async {
    isLoaded = false;

    final evnetref = await FirebaseFirestore.instance
        .collection("schedules")
        .doc(widget.id)
        .get();

    Map<String, dynamic> shareddata = evnetref.data()!;
    developer.log(evnetref["owner"]);
    eventlist = evnetref['events'];
    member = evnetref['member'];
    developer.log(eventlist.length.toString());
    contributor = evnetref['contributor'];
    personal = evnetref['personal'];
    nameController.text = evnetref['name'];

    if (evnetref["owner"] == FirebaseAuth.instance.currentUser!.email) {
      isowner = true;
      Map<String, dynamic> permissiondata = shareddata["permission"];
      setState(() {
        canedit = permissiondata["canedit"];
        caninvite = permissiondata["caninvite"];
        candelete = permissiondata["candelete"];
        canpermission = permissiondata["canpermission"];
      });
    } else {
      isowner = false;
      Map<String, dynamic> permissiondata = shareddata["permission"];
      developer.log(permissiondata.toString());
      checkcanedit = permissiondata["canedit"];
      checkcaninvite = permissiondata["caninvite"];
      checkcandelete = permissiondata["candelete"];
      checkcanpermission = permissiondata["canpermission"];

      setState(() {
        canedit = permissiondata["canedit"];
        caninvite = permissiondata["caninvite"];
        candelete = permissiondata["candelete"];
        canpermission = permissiondata["canpermission"];
      });
    }
    //developer.log(member[1]);
    final provider = Provider.of<EventProvider>(context, listen: false);
    provider.clearEvent();
    developer.log(eventlist.length.toString());
    for (var i = 0; i < eventlist.length; i++) {
      //developer.log(eventlist.length.toString());
      developer.log(eventlist[i].toString());
      final scheduledata = await FirebaseFirestore.instance
          .collection("events")
          .doc(eventlist[i])
          .get();

      //final scheduledata = schedata.data()!;
      if (evnetref.exists) {
        developer.log(eventlist[i].toString());
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

        developer.log(event.id);
        provider.addEvent(event);
      }
    }

    setState(() {
      isLoaded = true;
    });
  }

  Function(int)? hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
    return null;
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    final Event appointmentDetails = calendarTapDetails.appointments![0];
    developer.log(appointmentDetails.id.toString());
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
      developer.log(appointmentDetails.id.toString());
      if (isowner == true || checkcanedit == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UpdateEvent(
                    appointment: appointment,
                    id: widget.id,
                  )),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewEvent(
                    appointment: appointment,
                    //id: widget.id,
                  )),
        );
      }
    }
  }

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
    addEvent();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;

    return DefaultTabController(
        length: 3,
        child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
                toolbarHeight: 100,
                bottom: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  onTap: hideKeyboard(),
                  tabs: [
                    Tab(
                        icon: Icon(Icons.calendar_month_rounded,
                            color:
                                Theme.of(context).colorScheme.inverseSurface)),
                    Tab(
                        icon: Icon(Icons.people,
                            color:
                                Theme.of(context).colorScheme.inverseSurface)),
                    Tab(
                        icon: Icon(
                      Icons.settings,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    )),
                  ],
                ),
                title: SizedBox(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inverseSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: () => Clipboard.setData(
                            ClipboardData(text: widget.name2)),
                        child: Row(
                          children: [
                            Text(widget.name2,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inverseSurface
                                        .withOpacity(.7))),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.copy,
                              size: 13,
                            )
                          ],
                        ),
                      )
                    ])),
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
            body: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("schedules")
                    .doc(widget.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return TabBarView(controller: _tabController, children: [
                      Container(
                          height: displayHeight(context) * 0.7,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: personal == true
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Personal Schedule cannot be share. Please create new schedule class or share the appointment directly.",
                                    style: TextStyle(fontSize: 14),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              )
                            : Column(children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Contributors",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inverseSurface,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => invite(
                                                  docid: widget.id,
                                                  type: "Contributor",
                                                  name: widget.name,
                                                  existemail: contributor,
                                                ))),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inverseSurface
                                            .withOpacity(.07),
                                        border: Border.all(
                                          color: Colors.transparent,
                                          width:
                                              0.4, //                   <--- border width here
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(50.0)),
                                      ),
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const Icon(
                                            Icons.add_circle,
                                            size: 15,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text("Invite contributor",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .inverseSurface)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                    child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: contributor.length,
                                  itemBuilder: (context, index) => Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Memberedit(
                                        onTap: () => showdialog(
                                            context,
                                            "Are you sure want to delete ${contributor[index]["email"]}",
                                            "Please confirm",
                                            () => deleteMember(
                                                contributor[index]["uid"]
                                                    .toString(),
                                                contributor[index]["email"],
                                                2),
                                            () => Navigator.pop(context)),
                                        text: contributor[index]["email"],
                                        uid: contributor[index]["uid"],
                                      )),
                                )),
                                const SizedBox(
                                  height: 70,
                                ),
                                Text(
                                  "Members",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inverseSurface,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => invite(
                                                  docid: widget.id,
                                                  type: "Member",
                                                  name: widget.name,
                                                  existemail: member,
                                                ))),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inverseSurface
                                            .withOpacity(.07),
                                        border: Border.all(
                                          color: Colors.transparent,
                                          width:
                                              0.4, //                   <--- border width here
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(50.0)),
                                      ),
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const Icon(
                                            Icons.add_circle,
                                            size: 15,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text("Invite People",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .inverseSurface)),
                                        ],
                                      ),
                                    ),
                                  ),
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
                                      child: Memberedit(
                                          text: member[index]["email"],
                                          uid: member[index]["uid"],
                                          onTap: () => showdialog(
                                              context,
                                              "Are you sure want to delete ${member[index]["email"]}" +
                                                  "\n",
                                              "Please confirm",
                                              () => deleteMember(
                                                  member[index]["uid"]
                                                      .toString(),
                                                  member[index]["email"],
                                                  1),
                                              () => Navigator.pop(context)))),
                                )),
                              ]),
                      ),
                      Container(
                          child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: personal == true
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      TextButton(
                                        onPressed: () => showdialog(
                                            context,
                                            "Are you sure want to delete this schedule?",
                                            "There's no way to back up this action!",
                                            deleteschedule,
                                            () => Navigator.pop(context)),
                                        child: Container(
                                          height: 50,
                                          padding: const EdgeInsets.all(0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .inverseSurface,
                                                width: .3),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inverseSurface
                                                .withOpacity(.04),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "Clear Schedule",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ])
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      Text(
                                        "Schedule Name",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inverseSurface,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0),
                                        child: TextField(
                                          controller: nameController,
                                          obscureText: false,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .inverseSurface),
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(8)),
                                                borderSide: BorderSide(
                                                  width: 0.4,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .inverseSurface,
                                                )),
                                            errorBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.red,
                                                  width: 1.5),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              //<-- SEE HERE
                                              borderSide: BorderSide(
                                                width: 1.5,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(8)),
                                            ),
                                            focusedErrorBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.red,
                                                  width: 2.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                            ),
                                            //errorText: error,
                                            //labelText: TextStyle(Theme.of(context).textTheme.bodySmall),
                                            fillColor: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            //filled: isFilled,
                                            hintText: "Name",
                                            hintStyle: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .inverseSurface
                                                  .withAlpha(50),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            suffixIcon: IconButton(
                                              onPressed: () => showdialog(
                                                context,
                                                "Are you sure want to change this schedule name?",
                                                "Please confirm",
                                                () {
                                                  changeName();
                                                  Navigator.pop(context);
                                                },
                                                () {
                                                  returnname();
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              icon: const Icon(
                                                Icons.check,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      Text(
                                        "Contributors Permission",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inverseSurface,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Container(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(children: [
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("Edit Event",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .inverseSurface)),
                                                  Checkbox(
                                                    tristate: true,
                                                    value: canedit,
                                                    side: BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .inverseSurface,
                                                      width: 1.5,
                                                    ),
                                                    checkColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .background,
                                                    fillColor:
                                                        MaterialStateProperty
                                                            .resolveWith<
                                                                Color>((Set<
                                                                    MaterialState>
                                                                states) {
                                                      if (states.contains(
                                                          MaterialState
                                                              .selected)) {
                                                        return Theme.of(context)
                                                            .colorScheme
                                                            .inverseSurface;
                                                      } else {
                                                        return Colors
                                                            .transparent;
                                                      }
                                                    }),
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        if (value == null) {
                                                          canedit = false;
                                                        } else {
                                                          canedit = true;
                                                        }
                                                        setting();
                                                      });
                                                    },
                                                  ),
                                                ]),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("Edit/Invite Members",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .inverseSurface)),
                                                  Checkbox(
                                                    tristate: true,
                                                    value: caninvite,
                                                    side: BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .inverseSurface,
                                                      width: 1.5,
                                                    ),
                                                    checkColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .background,
                                                    fillColor:
                                                        MaterialStateProperty
                                                            .resolveWith<
                                                                Color>((Set<
                                                                    MaterialState>
                                                                states) {
                                                      if (states.contains(
                                                          MaterialState
                                                              .selected)) {
                                                        return Theme.of(context)
                                                            .colorScheme
                                                            .inverseSurface;
                                                      } else {
                                                        return Colors
                                                            .transparent;
                                                      }
                                                    }),
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        if (value == null) {
                                                          caninvite = false;
                                                        } else {
                                                          caninvite = true;
                                                        }
                                                        setting();
                                                      });
                                                    },
                                                  ),
                                                ]),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("Edit Permission",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .inverseSurface)),
                                                  Checkbox(
                                                    tristate: true,
                                                    value: canpermission,
                                                    side: BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .inverseSurface,
                                                      width: 1.5,
                                                    ),
                                                    checkColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .background,
                                                    fillColor:
                                                        MaterialStateProperty
                                                            .resolveWith<
                                                                Color>((Set<
                                                                    MaterialState>
                                                                states) {
                                                      if (states.contains(
                                                          MaterialState
                                                              .selected)) {
                                                        return Theme.of(context)
                                                            .colorScheme
                                                            .inverseSurface;
                                                      } else {
                                                        return Colors
                                                            .transparent;
                                                      }
                                                    }),
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        if (value == null) {
                                                          canpermission = false;
                                                        } else {
                                                          canpermission = true;
                                                        }
                                                        setting();
                                                      });
                                                    },
                                                  ),
                                                ]),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("Delete *This Schedule*",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .inverseSurface)),
                                                  Checkbox(
                                                    tristate: true,
                                                    value: candelete,
                                                    side: BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .inverseSurface,
                                                      width: 1.5,
                                                    ),
                                                    checkColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .background,
                                                    fillColor:
                                                        MaterialStateProperty
                                                            .resolveWith<
                                                                Color>((Set<
                                                                    MaterialState>
                                                                states) {
                                                      if (states.contains(
                                                          MaterialState
                                                              .selected)) {
                                                        return Theme.of(context)
                                                            .colorScheme
                                                            .inverseSurface;
                                                      } else {
                                                        return Colors
                                                            .transparent;
                                                      }
                                                    }),
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        if (value == null) {
                                                          candelete = false;
                                                        } else {
                                                          candelete = true;
                                                        }
                                                        setting();
                                                      });
                                                    },
                                                  ),
                                                ]),
                                          ])),
                                      TextButton(
                                        onPressed: () => showdialog(
                                            context,
                                            "Are you sure want to delete this schedule?",
                                            "There's no way to back up this action!",
                                            deleteschedule,
                                            () => Navigator.pop(context)),
                                        child: Container(
                                          height: 50,
                                          padding: const EdgeInsets.all(0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .inverseSurface,
                                                width: .3),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inverseSurface
                                                .withOpacity(.04),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "Delete",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ]),
                        ),
                      )),
                    ]);
                  } else {
                    return const Center(
                      child: Text("No data"),
                    );
                  }
                }),
            floatingActionButton: _bottomButtons()));
  }

  Widget _bottomButtons() {
    //developer.log(_tabController.index.toString());
    return _tabController.index == 0
        ? /*Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Expanded(child: Container()),
            FloatingActionButton(
                elevation: 0,
                onPressed: () => addevent2(),
                child: const Text(
                  "",
                  style: TextStyle(fontSize: 10),
                )),
            ToggleButtons(
              direction: Axis.horizontal,
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < isSelected.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      isSelected[buttonIndex] = true;
                    } else {
                      isSelected[buttonIndex] = false;
                    }
                  }
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: Colors.red[700],
              selectedColor: Colors.white,
              fillColor: Colors.red[200],
              color: Colors.red[400],
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 80.0,
              ),
              isSelected: isSelected,
              children: schedule,
            ),
            Expanded(child: Container()),
            FloatingActionButton(
                elevation: 0,
                onPressed: () => addevent2(),
                child: const Icon(
                  Icons.add,
                )),
          ])*/
        FloatingActionButton(
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.primary,
            onPressed: () => addevent2(),
            child: const Icon(
              Icons.add,
            ))
        : const FloatingActionButton(
            shape: StadiumBorder(),
            onPressed: null,
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: SizedBox(
              width: 1,
            ));
  }
}
