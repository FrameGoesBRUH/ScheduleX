import 'dart:async';
import 'package:flutter/services.dart';

import 'package:schedulex/size.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class invite extends StatefulWidget {
  final String docid;
  final String type;
  final String name;
  final List<dynamic> existemail;
  const invite(
      {super.key,
      required this.docid,
      required this.type,
      required this.name,
      required this.existemail});

  @override
  State<invite> createState() => _inviteState();
}

class _inviteState extends State<invite> {
  //final nameController = TextEditingController();
  var errorstr;
  List<String> useremail = <String>[];
  List<Map> user = <Map>[];
  late TextfieldTagsController people;
  bool member = false;

  @override
  void dispose() {
    super.dispose();
    people.dispose();
  }

  @override
  void initState() {
    super.initState();
    getUser();
    people = TextfieldTagsController();
  }

  Future getUser() async {
    final userref = await FirebaseFirestore.instance.collection("users").get();
    for (var document in userref.docs) {
      if (document.exists) {
        Map<String, dynamic> userdata = document.data();
        Map<String, dynamic> adddata = {
          "email": userdata["email"],
          "uid": document.id
        };
        useremail.add(userdata["email"]);
        user.add(adddata);
      }

      setState(() {
        if (widget.type == "Member") {
          member = true;
        } else {
          member = false;
        }
      });
    }
  }

  Future invite() async {
    if (people.getTags!.isEmpty) {
      setState(() {
        errorstr = "You need to add the email!";
      });
    } else {
      final scheduleref =
          FirebaseFirestore.instance.collection("schedules").doc();

      List<dynamic> peopletag = [];
      people.getTags?.forEach((element) {
        peopletag.add(element.toString());
      });

      if (people.getTags!.isNotEmpty) {
        for (var i = 0; i < people.getTags!.length; i++) {
          for (var u = 0; u < user.length; u++) {
            if (people.getTags![i].toString() == user[u]["email"].toString()) {
              final emaildoc = FirebaseFirestore.instance
                  .collection("users")
                  .doc(user[u]["uid"].toString());

              //dev.log(user[i]["uid"].toString());
              final userdatainbox = <String, dynamic>{
                "email": FirebaseAuth.instance.currentUser!.email,
                "type": widget.type.toLowerCase(),
                "id": widget.docid,
                "name": widget.name,
              };
              emaildoc.update({
                "inbox": FieldValue.arrayUnion([userdatainbox])
              });
            }
          }
        }
      } else {
        Navigator.pop(context);
      }
      Navigator.pop(context);
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
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.close,
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
            actions: [
              Row(children: [
                IconButton(
                  onPressed: invite,
                  icon: Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                ),
              ])
            ]),
        body: Padding(
            padding: const EdgeInsets.all(25),
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Row(children: [
                    Text("Invite ${widget.type.toString()}"),
                    //Text("Get your Schedule ID from the Admin"),
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                  Autocomplete<String>(
                    optionsViewBuilder: (context, onSelected, options) {
                      return Container(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Material(
                            elevation: 4.0,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 200),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: options.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final dynamic option =
                                      options.elementAt(index);
                                  return TextButton(
                                    onPressed: () {
                                      onSelected(option);
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15.0),
                                        child: Text(
                                          '$option',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inverseSurface,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return const Iterable<String>.empty();
                      }
                      return useremail.where((String option) {
                        return option
                            .contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (String selectedTag) {
                      people.addTag = selectedTag;
                    },
                    fieldViewBuilder: (context, ttec, tfn, onFieldSubmitted) {
                      return TextFieldTags(
                        textEditingController: ttec,
                        focusNode: tfn,
                        textfieldTagsController: people,
                        initialTags: const [],
                        textSeparators: const [' ', ','],
                        letterCase: LetterCase.normal,
                        validator: (String tag) {
                          if (people.getTags!.contains(tag)) {
                            return 'you already entered that';
                          }
                          if (widget.existemail.contains(tag)) {
                            return 'This email has already joined';
                          }
                          return null;
                        },
                        inputfieldBuilder:
                            (context, tec, fn, error, onChanged, onSubmitted) {
                          return ((context, sc, tags, onTagDelete) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
                              child: TextField(
                                controller: tec,
                                focusNode: fn,
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      borderSide: BorderSide(
                                          width: 3, color: Colors.transparent)),
                                  errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 2.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    //<-- SEE HERE
                                    borderSide: BorderSide(
                                        width: 3, color: Colors.transparent),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  focusedErrorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 2.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  fillColor: Theme.of(context)
                                      .colorScheme
                                      .inverseSurface,
                                  //helperText: 'Enter language...',

                                  hintText: people.hasTags
                                      ? ''
                                      : "Enter peoples email...",
                                  errorText: error,
                                  prefixIconConstraints: BoxConstraints(
                                      maxWidth: displayWidth(context) * 0.74),
                                  prefixIcon: tags.isNotEmpty
                                      ? SingleChildScrollView(
                                          controller: sc,
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                              children: tags.map((String tag) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(20.0),
                                                ),
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                    .withOpacity(.8),
                                              ),
                                              margin: const EdgeInsets.only(
                                                  right: 10.0),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 4.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    child: Text(
                                                      '@$tag',
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    onTap: () {
                                                      //print("$tag selected");
                                                    },
                                                  ),
                                                  const SizedBox(width: 4.0),
                                                  InkWell(
                                                    child: const Icon(
                                                      Icons.cancel,
                                                      size: 14.0,
                                                      color: Color.fromARGB(
                                                          255, 233, 233, 233),
                                                    ),
                                                    onTap: () {
                                                      onTagDelete(tag);
                                                    },
                                                  )
                                                ],
                                              ),
                                            );
                                          }).toList()),
                                        )
                                      : null,
                                ),
                                onChanged: onChanged,
                                onSubmitted: onSubmitted,
                              ),
                            );
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      child: member
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Text("Or share this ID with your member",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inverseSurface)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      // color: Colors.transparent,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(.8),
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: GestureDetector(
                                      onTap: () => Clipboard.setData(
                                          ClipboardData(text: widget.docid)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(widget.docid,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .inverseSurface)),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const Icon(
                                            Icons.copy,
                                            size: 15,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ])
                          : const SizedBox(
                              height: 1,
                            ))
                ]))));
  }
}
