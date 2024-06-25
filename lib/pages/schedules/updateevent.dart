import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schedulex/provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../model/event.dart';
import 'package:schedulex/size.dart';
import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'components/textfield.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

const List<Widget> reccur = <Widget>[
  Text(
    'Day',
    style: TextStyle(fontSize: 12),
    overflow: TextOverflow.ellipsis,
  ),
  Text(
    'Week',
    style: TextStyle(fontSize: 12),
    overflow: TextOverflow.ellipsis,
  ),
  Text(
    'Month',
    style: TextStyle(fontSize: 12),
    overflow: TextOverflow.ellipsis,
  ),
  Text(
    "mo.End",
    style: TextStyle(fontSize: 12),
    overflow: TextOverflow.ellipsis,
  )
];

class UpdateEvent extends StatefulWidget {
  Event? appointment;
  String id;

  UpdateEvent({super.key, this.appointment, required this.id});

  @override
  State<UpdateEvent> createState() => _UpdateEventState();
}

class _UpdateEventState extends State<UpdateEvent> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now().add(const Duration(hours: 2));
  DateTime untilDate = DateTime.now();

  bool isChecked = false;

  Color backgroundColor = Colors.orange.withOpacity(.8);

  var nameerror;

  String reccurrule = "";

  //final bool isowner = false;

  final List<bool> isSelected = <bool>[false, false, false, false];
  final nameController = TextEditingController();
  final noteController = TextEditingController();

  Future updateEvent() async {
    if (nameController.text.isEmpty) {
      setState(() {
        nameerror = "Name required";
      });
    } else {
      if (isSelected[0] == true) {
        reccurrule =
            "FREQ=DAILY;UNTIL=${untilDate.year}${untilDate.month.toString().padLeft(2, '0')}${untilDate.day.toString().padLeft(2, '0')}T240000Z;";
      } else if (isSelected[1] == true) {
        reccurrule =
            "FREQ=WEEKLY;INTERVAL=1;BYDAY=${DateFormat.E().format(untilDate).toUpperCase().substring(0, 2)};UNTIL=${untilDate.year}${untilDate.month.toString().padLeft(2, '0')}${untilDate.day.toString().padLeft(2, '0')}T230000Z;";
      } else if (isSelected[2] == true) {
        reccurrule =
            "FREQ=MONTHLY;BYMONTHDAY=${DateFormat.d().format(untilDate)};UNTIL=${untilDate.year}${untilDate.month.toString().padLeft(2, '0')}${untilDate.day.toString().padLeft(2, '0')}T230000Z;";
      } else if (isSelected[3] == true) {
        reccurrule =
            "FREQ=YEARLY;BYMONTHDAY=${DateFormat.d().format(untilDate)};BYMONTH=${DateFormat.M().format(untilDate)};UNTIL=${untilDate.year}${untilDate.month.toString().padLeft(2, '0')}${untilDate.day.toString().padLeft(2, '0')}T240000Z;";
      } else {
        reccurrule = "";
      }
      //fromDate = widget.appointment!.from;
      //toDate = widget.appointment!.to;
      /*noteController.text = widget.appointment!.description;
      nameController.text = widget.appointment!.title;
      isChecked = widget.appointment!.isAllDay;
      backgroundColor = widget.appointment!.backgroundColor;
*/
      developer.log(widget.appointment!.id);
      final scheduleref =
          FirebaseFirestore.instance.collection("schedules").doc(widget.id);
      final eventsref = FirebaseFirestore.instance
          .collection("events")
          .doc(widget.appointment!.id);

      final event = Event(
          title: nameController.text,
          description: noteController.text,
          from: fromDate,
          to: toDate,
          backgroundColor: backgroundColor,
          isAllDay: isChecked,
          recurrenceRule: reccurrule,
          department: "development",
          id: widget.appointment!.id);
      final oldevent = Event(
          title: widget.appointment!.title,
          description: widget.appointment!.description,
          from: widget.appointment!.from,
          to: widget.appointment!.to,
          backgroundColor: widget.appointment!.backgroundColor,
          isAllDay: widget.appointment!.isAllDay,
          recurrenceRule: widget.appointment!.recurrenceRule,
          department: "development",
          id: widget.appointment!.id);
      final eventdata = <String, dynamic>{
        "title": nameController.text,
        "description": noteController.text,
        "from": fromDate,
        "to": toDate,
        "backgroundColor": backgroundColor.value,
        "isAllDay": isChecked,
        "recurrenceRule": reccurrule.toString(),
        "id": widget.appointment!.id,
        //"department": "development",
      };
      final oldeventdata = <String, dynamic>{
        "title": widget.appointment!.title,
        "description": widget.appointment!.description,
        "from": widget.appointment!.from,
        "to": widget.appointment!.to,
        "backgroundColor": widget.appointment!.backgroundColor.value,
        "isAllDay": widget.appointment!.isAllDay,
        "recurrenceRule": widget.appointment!.recurrenceRule,
        "id": widget.appointment!.id,
        //"department": "development",
      };

      developer.log(oldeventdata.toString());
      final provider = Provider.of<EventProvider>(context, listen: false);

      eventsref.update(eventdata);

      provider.removeEvent(widget.appointment!.id);
      provider.addEvent(event);
      Navigator.of(context).pop();
    }
  }

  void showDate(int dateType) {
    var inndate = DateTime.now();
    if (dateType == 0) {
      inndate = fromDate;
    } else if (dateType == 1) {
      inndate = toDate;
    } else {
      inndate = untilDate;
    }
    showDatePicker(
            context: context,
            initialDate: inndate,
            firstDate: DateTime(2022),
            lastDate: DateTime(9000))
        .then((value) {
      setState(() {
        if (dateType == 0) {
          if (value!.isBefore(toDate)) {
            fromDate = value;
          } else {
            fromDate = value;
            toDate = value.add(const Duration(hours: 2));
          }
        } else if (dateType == 1) {
          if (value!.isAfter(fromDate)) {
            toDate = value;
          } else {
            toDate = value;
            fromDate = value.add(const Duration(hours: 2));
          }
        } else {
          if (value!.isAfter(toDate)) {
            untilDate = value;
          }
        }
      });
    });
  }

  void showTime(int dateType) {
    var datecheck = DateTime.now();

    var inndate = TimeOfDay.now();
    if (dateType == 0) {
      inndate = TimeOfDay(hour: fromDate.hour, minute: fromDate.minute);
    } else {
      inndate = TimeOfDay(hour: toDate.hour, minute: toDate.minute);
    }
    //int hours;
    showTimePicker(
        context: context,
        initialTime: inndate,
        builder: (context, child) => Theme(
              data: ThemeData().copyWith(
                  timePickerTheme: TimePickerThemeData(
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .background, // Background color
                    hourMinuteTextColor: Theme.of(context)
                        .colorScheme
                        .inverseSurface, // Text color for hours and minutes
                    dayPeriodTextColor: Theme.of(context)
                        .colorScheme
                        .inverseSurface, // Text color for AM/PM
                    //dayPeriodBorderSide: BorderSide(color: Theme.of(context).colorScheme.surface), // Border color for AM/PM
                    dialHandColor: Theme.of(context)
                        .colorScheme
                        .primary, // Color of the hour hand
                    dialTextColor: Theme.of(context)
                        .colorScheme
                        .inverseSurface, // Text color on the clock dial
                    dialBackgroundColor: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.1),
                    //dayPeriodColor: lightBlue,
                    //hourMinuteColor: lightBlue,
                    //entryModeIconColor: blueStanOut,
                    //helpTextStyle: const TextStyle(
                    //  color: blueStanOut, // Set the text color for "Enter time"
                    //),
                    //cancelButtonStyle: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.brown.shade300), foregroundColor:MaterialStateProperty.all<Color>(darkGreen)),
                    //confirmButtonStyle: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.brown.shade300), foregroundColor:MaterialStateProperty.all<Color>(darkGreen)),
                    //hourMinuteTextStyle: TextStyle(fontSize: 30), // Text style for hours and minutes
                  ),
                  colorScheme: ColorScheme.dark(
                      surface: Theme.of(context).colorScheme.surface,
                      primary: Theme.of(context).colorScheme.primary)),
              child: child!,
            )).then((value) {
      setState(() {
        if (dateType == 0) {
          var valuedate = DateTime(fromDate.year, fromDate.month, fromDate.day,
              value!.hour, value.minute);
          datecheck = DateTime(toDate.year, toDate.month, toDate.day,
              toDate.hour, toDate.minute);
          if (valuedate.isBefore(datecheck)) {
            fromDate = valuedate;
          } else {
            fromDate = valuedate;
            toDate = valuedate.add(const Duration(hours: 2));
          }
        } else {
          var valuedate = DateTime(
              toDate.year, toDate.month, toDate.day, value!.hour, value.minute);
          datecheck = DateTime(fromDate.year, fromDate.month, toDate.day,
              fromDate.hour, fromDate.minute);
          if (valuedate.isAfter(datecheck)) {
            toDate = valuedate;
          }
        }
      });
    });
  }

  Widget buildColorPicker() => MaterialColorPicker(
        onColorChange: (Color color) {
          // Handle color change
          setState(() {
            backgroundColor = color.withOpacity(.8);
          });
        },
        selectedColor: Theme.of(context).colorScheme.primary,
        colors: const [
          Colors.orangeAccent,
          Colors.orange,
          Colors.deepOrange,
          Colors.yellow,
          Colors.lightGreen,
          Colors.greenAccent,
          Colors.cyan,
          Colors.blue,
          Colors.purple,
          Colors.red,
          Colors.teal,
          Colors.indigoAccent,
          Colors.amber,
          Colors.blueGrey,
          Colors.teal,
        ],
      );

  void pickColor(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Pick the background color"),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildColorPicker(),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Select"))
              ],
            ),
          ));

  Future addconfig() async {
    setState(() {
      fromDate = widget.appointment!.from;
      toDate = widget.appointment!.to;
      noteController.text = widget.appointment!.description;
      nameController.text = widget.appointment!.title;
      isChecked = widget.appointment!.isAllDay;
      backgroundColor = widget.appointment!.backgroundColor;
      RecurrenceProperties recurrenceProperties =
          SfCalendar.parseRRule(widget.appointment!.recurrenceRule, fromDate);
      if (recurrenceProperties.recurrenceType == RecurrenceType.daily) {
        isSelected[0] = true;
        isSelected[1] = false;
        isSelected[2] = false;
        isSelected[3] = false;
      } else if (recurrenceProperties.recurrenceType == RecurrenceType.weekly) {
        isSelected[0] = false;
        isSelected[1] = true;
        isSelected[2] = false;
        isSelected[3] = false;
      } else if (recurrenceProperties.recurrenceType ==
          RecurrenceType.monthly) {
        isSelected[0] = false;
        isSelected[1] = false;
        isSelected[2] = true;
        isSelected[3] = false;
      } else if (recurrenceProperties.recurrenceType == RecurrenceType.yearly) {
        isSelected[0] = false;
        isSelected[1] = false;
        isSelected[2] = false;
        isSelected[3] = true;
      } else {
        isSelected[0] = false;
        isSelected[1] = false;
        isSelected[2] = false;
        isSelected[3] = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    addconfig();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
            iconTheme: IconThemeData(
                color: Theme.of(context).colorScheme.inverseSurface),
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.background,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.close,
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
            actions: [
              Row(children: [
                IconButton(
                  onPressed: updateEvent,
                  icon: Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                ),
              ])
            ]),

        //drawer: const DrawerNav(),
        body: SingleChildScrollView(
            child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Container(
                    constraints: BoxConstraints(
                        maxWidth: displayHeight(context) +
                            displayWidth(context) * 0.1),
                    padding: EdgeInsets.symmetric(
                        horizontal: displayWidth(context) * 0.05),
                    alignment: Alignment.center,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyTextField(
                            controller: nameController,
                            hintText: 'Name',
                            obscureText: false,
                            error: nameerror,
                            isFilled: false,
                            padding: 0, border: true,

                            //errorText: _wrongemail ? "Wrong Email" : null,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  Text("All day",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inverseSurface)),
                                  Checkbox(
                                    tristate: true,
                                    value: isChecked,
                                    side: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 1.5,
                                    ),
                                    checkColor: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    fillColor:
                                        MaterialStateProperty.resolveWith<
                                            Color>((Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.selected)) {
                                        return Theme.of(context)
                                            .colorScheme
                                            .primary;
                                      } else {
                                        return Colors.transparent;
                                      }
                                    }),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == null) {
                                          isChecked = false;
                                        } else {
                                          isChecked = true;
                                        }
                                      });
                                    },
                                  ),
                                ]),
                                Row(children: [
                                  Text("Color",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inverseSurface)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                      onTap: () => pickColor(context),
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                          border: Border.all(
                                              width: 2,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .inverseSurface
                                                  .withOpacity(0.2)),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Flexible(
                                          child: FractionallySizedBox(
                                            heightFactor:
                                                0.9, // Adjust those two for the white space
                                            widthFactor: 0.9,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: backgroundColor,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                                ]),
                              ]),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(children: [
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey[400],
                              ),
                            ),
                          ]),
                          const SizedBox(
                            height: 20,
                          ),
                          Text("From",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inverseSurface)),

                          //width: 30.w,
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      // color: Colors.transparent,

                                      border: Border.all(
                                          width: 1.5,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inverseSurface
                                              .withOpacity(0.08)),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    child: TextButton(
                                        // <-- OutlinedButton
                                        style: ButtonStyle(
                                          shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )),
                                        ),
                                        onPressed: () {
                                          showDate(0);
                                        },
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const Icon(
                                                  Icons.arrow_drop_down,
                                                  size: 24.0,
                                                ),
                                                AutoSizeText(
                                                  DateFormat.MMMEd()
                                                      .format(fromDate),
                                                  maxLines: 1,
                                                ),
                                              ]),
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  width: displayWidth(context) * 0.03,
                                ),
                                Expanded(
                                  child: Container(
                                    width: displayWidth(context) * 0.35,
                                    decoration: BoxDecoration(
                                      // color: Colors.transparent,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      border: Border.all(
                                        width: 1.5,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inverseSurface
                                            .withOpacity(0.08),
                                      ),
                                    ),
                                    child: TextButton(

                                        // <-- OutlinedButton
                                        style: ButtonStyle(
                                          shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )),
                                        ),
                                        onPressed: isChecked == false
                                            ? () {
                                                showTime(0);
                                              }
                                            : null,
                                        child: FittedBox(
                                            fit: BoxFit.contain,
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  const Icon(
                                                    Icons.arrow_drop_down,
                                                    size: 24.0,
                                                  ),
                                                  AutoSizeText(
                                                    TimeOfDay(
                                                            hour: fromDate.hour,
                                                            minute:
                                                                fromDate.minute)
                                                        .format(context),
                                                    maxLines: 1,
                                                    //overflow: TextOverflow.ellipsis,
                                                  )
                                                ]))),
                                  ),
                                ),
                              ]),
                          const SizedBox(
                            height: 20,
                          ),
                          const Align(
                            alignment: Alignment.center,
                            child: Icon(Icons.arrow_downward),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text("To",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inverseSurface)),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      // color: Colors.transparent,

                                      border: Border.all(
                                          width: 1.5,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inverseSurface
                                              .withOpacity(0.08)),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    child: TextButton(
                                        // <-- OutlinedButton
                                        style: ButtonStyle(
                                          shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )),
                                        ),
                                        onPressed: () {
                                          showDate(1);
                                        },
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const Icon(
                                                  Icons.arrow_drop_down,
                                                  size: 24.0,
                                                ),
                                                AutoSizeText(
                                                  DateFormat.MMMEd()
                                                      .format(toDate),
                                                  maxLines: 1,
                                                ),
                                              ]),
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  width: displayWidth(context) * 0.03,
                                ),
                                Expanded(
                                  child: Container(
                                    width: displayWidth(context) * 0.35,
                                    decoration: BoxDecoration(
                                      // color: Colors.transparent,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      border: Border.all(
                                          width: 1.5,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inverseSurface
                                              .withOpacity(0.08)),
                                    ),
                                    child: TextButton(

                                        // <-- OutlinedButton
                                        style: ButtonStyle(
                                          shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )),
                                        ),
                                        onPressed: isChecked == false
                                            ? () {
                                                showTime(1);
                                              }
                                            : null,
                                        child: FittedBox(
                                            fit: BoxFit.contain,
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  const Icon(
                                                    Icons.arrow_drop_down,
                                                    size: 24.0,
                                                  ),
                                                  AutoSizeText(
                                                    TimeOfDay(
                                                            hour: toDate.hour,
                                                            minute:
                                                                toDate.minute)
                                                        .format(context),
                                                    maxLines: 1,
                                                    //overflow: TextOverflow.ellipsis,
                                                  )
                                                ]))),
                                  ),
                                ),
                              ]),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(children: [
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey[400],
                              ),
                            ),
                          ]),
                          const SizedBox(
                            height: 20,
                          ),
                          Text("Repeat",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inverseSurface)),

                          Align(
                            alignment: Alignment.center,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    ToggleButtons(
                                      //direction: vertical ? Axis.vertical : Axis.horizontal,
                                      onPressed: (int index) {
                                        setState(() {
                                          // The button that is tapped is set to true, and the others to false.
                                          for (int buttonIndex = 0;
                                              buttonIndex < isSelected.length;
                                              buttonIndex++) {
                                            if (buttonIndex == index) {
                                              isSelected[buttonIndex] =
                                                  !isSelected[buttonIndex];
                                            } else {
                                              isSelected[buttonIndex] = false;
                                            }
                                          }
                                        });
                                      },
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      selectedBorderColor:
                                          Theme.of(context).colorScheme.primary,
                                      selectedColor: Theme.of(context)
                                          .colorScheme
                                          .inverseSurface,
                                      fillColor: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(.2),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inverseSurface,
                                      constraints: BoxConstraints(
                                        maxWidth: displayHeight(context) +
                                            displayWidth(context) * 0.1 * 0.9,
                                        minHeight: 30,
                                        minWidth: (((MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            1.2 +
                                                        displayHeight(context) *
                                                            0.9)) /
                                                    4)
                                                .clamp(
                                                    0,
                                                    displayHeight(context) +
                                                        displayWidth(context) *
                                                            0.1) /
                                            4,
                                      ),

                                      isSelected: isSelected,
                                      children: reccur,
                                    ),
                                  ]),
                            ),
                          ),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Until",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inverseSurface
                                          .withOpacity(0.9)),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                TextButton(
                                  // <-- OutlinedButton
                                  style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                                  ),
                                  onPressed: isSelected[1] == true ||
                                          isSelected[2] == true ||
                                          isSelected[3] == true ||
                                          isSelected[0] == true
                                      ? () {
                                          showDate(2);
                                        }
                                      : null,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Icon(
                                            Icons.arrow_drop_down,
                                            size: 24.0,
                                          ),
                                          AutoSizeText(
                                            DateFormat.yMMMMEEEEd()
                                                .format(toDate),
                                            maxLines: 1,
                                          ),
                                        ]),
                                  ),
                                ),
                              ]),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(children: [
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey[400],
                              ),
                            ),
                          ]),
                          const SizedBox(
                            height: 20,
                          ),
                          Text("Note",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inverseSurface)),

                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.5,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inverseSurface
                                      .withOpacity(0.08)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                            ),
                            height: displayHeight(context) * 0.2,
                            child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextField(
                                    controller: noteController,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 10,
                                    //obscureText: obscureText,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inverseSurface),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,

                                      //errorText: error,
                                      //labelText: TextStyle(Theme.of(context).textTheme.bodySmall),
                                      fillColor: Colors.transparent,

                                      hintText: "Add Notes",
                                      hintStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inverseSurface
                                            .withOpacity(.3),
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ))),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ])))));
  }
}
