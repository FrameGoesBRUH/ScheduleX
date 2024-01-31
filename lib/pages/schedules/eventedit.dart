import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schedulex/provider/provider.dart';
import '../model/event.dart';
import 'package:schedulex/size.dart';
import 'dart:developer' as developer;
import '../mainComponents/baseAppBar.dart';
import '../mainComponents/drawer.dart';
import 'components/my_button.dart';
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

class EventEdit extends StatefulWidget {
  final Event? event;

  const EventEdit({super.key, required this.event});

  @override
  State<EventEdit> createState() => _EventEditState();
}

class _EventEditState extends State<EventEdit> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  bool isChecked = false;

  Color backgroundColor = Colors.orange.withOpacity(.8);

  var nameerror = null;

  final List<bool> isSelected = <bool>[false, false, false, false];
  final nameController = TextEditingController();
  final noteController = TextEditingController();

  Future addEvent() async {
    if (nameController.text.isEmpty) {
      setState(() {
        nameerror = "Name required";
      });
    } else {
      final event = Event(
        title: nameController.text,
        description: noteController.text,
        from: fromDate,
        to: toDate,
        backgroundColor: backgroundColor,
        isAllDay: isChecked,
      );
      developer.log(event.title.toString());
      final provider = Provider.of<EventProvider>(context, listen: false);
      provider.addEvent(event);

      Navigator.of(context).pop();
    }
  }

  void showDate(int dateType) {
    var inndate = DateTime.now();
    if (dateType == 0) {
      inndate = fromDate;
    } else {
      inndate = toDate;
    }
    showDatePicker(
            context: context,
            initialDate: inndate,
            firstDate: DateTime(2022),
            lastDate: DateTime(9000))
        .then((value) {
      setState(() {
        if (dateType == 0) {
          if (value!.year <= toDate.year) {
            if (value.month <= toDate.month) {
              if (value.day <= toDate.day) {
                fromDate = value;
              } else {
                fromDate = value;

                toDate = DateTime(fromDate.year, fromDate.month, value.day);
              }
            } else {
              fromDate = value;
              toDate = DateTime(fromDate.year, value.month);
            }
          } else {
            fromDate = value;
            toDate = DateTime(value.year);
          }
        } else {
          if (value!.year >= fromDate.year) {
            if (value.month >= fromDate.month) {
              if (value.day >= fromDate.day) {
                toDate = value;
              } else {
                toDate = value;

                fromDate = DateTime(fromDate.year, fromDate.month, value.day);
              }
            } else {
              toDate = value;
              fromDate = DateTime(fromDate.year, value.month);
            }
          } else {
            toDate = value;
            fromDate = DateTime(value.year);
          }
        }
      });
    });
  }

  void showTime(int dateType) {
    var inndate = TimeOfDay.now();
    if (dateType == 0) {
      inndate = TimeOfDay(hour: fromDate.hour, minute: fromDate.minute);
    } else {
      inndate = TimeOfDay(hour: toDate.hour, minute: toDate.minute);
    }
    //int hours;
    showTimePicker(context: context, initialTime: inndate).then((value) {
      setState(() {
        if (dateType == 0) {
          if (value!.hour <= toDate.hour) {
            if (value.minute < toDate.minute) {
              fromDate = DateTime(toDate.year, toDate.month, toDate.day,
                  value.hour, value.minute);
            } else {
              toDate = DateTime(toDate.year, toDate.month, toDate.day,
                  value.hour, value.minute);
              fromDate = DateTime(fromDate.year, fromDate.month, fromDate.day,
                  fromDate.hour, value.minute);
            }
          } else {
            toDate = DateTime(toDate.year, toDate.month, toDate.day, value.hour,
                value.minute);
            fromDate = DateTime(fromDate.year, fromDate.month, fromDate.day,
                value.hour, value.minute);
          }
        } else {
          if (value!.hour > fromDate.hour) {
            toDate = DateTime(toDate.year, toDate.month, toDate.day, value.hour,
                value.minute);
          } else {
            if (toDate.year >= fromDate.year &&
                toDate.month >= fromDate.month &&
                toDate.day > fromDate.day) {
              toDate = DateTime(toDate.year, toDate.month, toDate.day,
                  value.hour, value.minute);
            }
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
        colors: [
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
            title: Text("Pick the background color"),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildColorPicker(),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Select"))
              ],
            ),
          ));

  @override
  void initState() {
    super.initState();

    if (widget.event == null) {
      fromDate = DateTime.now();
      //toDate = DateTime.now().add(const Duration(hours: 1));
    }
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
              onPressed: null,
              icon: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
            actions: [
              IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).colorScheme.inverseSurface,
                ),
              ),
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
                            isFilled: true,
                            padding: 0,

                            //errorText: _wrongemail ? "Wrong Email" : null,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  Text("All day"),
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
                                GestureDetector(
                                  onTap: () => pickColor(context),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: backgroundColor),
                                    //color: backgroundColor,
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                              ]),
                          const SizedBox(
                            height: 20,
                          ),

                          Text("From"),

                          //width: 30.w,

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                    // <-- OutlinedButton
                                    style: ButtonStyle(
                                      shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
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
                                TextButton(

                                    // <-- OutlinedButton
                                    style: ButtonStyle(
                                      shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                    ),
                                    onPressed: () {
                                      showTime(0);
                                    },
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Icon(
                                            Icons.arrow_drop_down,
                                            size: 24.0,
                                          ),
                                          Text(
                                            TimeOfDay(
                                                    hour: fromDate.hour,
                                                    minute: fromDate.minute)
                                                .format(context),
                                            //overflow: TextOverflow.ellipsis,
                                          )
                                        ])),
                              ]),
                          SizedBox(
                            height: 10,
                          ),
                          Text("To"),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  // <-- OutlinedButton
                                  style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
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
                                            DateFormat.MMMEd().format(toDate),
                                            maxLines: 1,
                                          ),
                                        ]),
                                  ),
                                ),
                                TextButton(

                                    // <-- OutlinedButton
                                    style: ButtonStyle(
                                      shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                    ),
                                    onPressed: () {
                                      showTime(1);
                                    },
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Icon(
                                            Icons.arrow_drop_down,
                                            size: 24.0,
                                          ),
                                          Text(
                                            TimeOfDay(
                                                    hour: toDate.hour,
                                                    minute: toDate.minute)
                                                .format(context),
                                            // overflow: TextOverflow.ellipsis,
                                          )
                                        ])),
                              ]),
                          const SizedBox(
                            height: 25,
                          ),
                          Text("Repeat"),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
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
                                    minWidth:
                                        (((MediaQuery.of(context).size.width *
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
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          Text("Note"),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface
                                    .withOpacity(.5),
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                            ),
                            height: displayHeight(context) * 0.4,
                            child: Padding(
                                padding: EdgeInsets.all(10),
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
                          Row(children: [
                            Expanded(
                              child: MyButton(
                                text: "Cancle",
                                onTap: () => Navigator.of(context).pop(),
                              ),
                            ),
                            Expanded(
                              child: MyButton(
                                text: "Add",
                                onTap: addEvent,
                              ),
                            ),
                          ])
                        ])))));
  }
}
