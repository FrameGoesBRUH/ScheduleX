import 'dart:async';
import 'package:schedulex/pages/schedules/sharedlist.dart';
import 'package:schedulex/size.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:flutter/material.dart';
import 'components/textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class create extends StatefulWidget {
  const create({super.key});

  @override
  State<create> createState() => _createState();
}

class _createState extends State<create> {
  final nameController = TextEditingController();
  var errorstr;
  List<String> useremail = <String>[];
  List<Map> user = <Map>[];
  late TextfieldTagsController member;
  late TextfieldTagsController contributor;

  @override
  void dispose() {
    super.dispose();
    member.dispose();
    contributor.dispose();
  }

  @override
  void initState() {
    super.initState();
    getUser();
    member = TextfieldTagsController();
    contributor = TextfieldTagsController();
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
    }
  }

  Future create() async {
    var docid;
    if (nameController.text.isEmpty) {
      setState(() {
        errorstr = "You need to enter the name!";
      });
    } else {
      final scheduleref =
          FirebaseFirestore.instance.collection("schedules").doc();

      List<dynamic> membertag = [];
      List<dynamic> contag = [];
      member.getTags?.forEach((element) {
        membertag.add(element.toString());
      });
      contributor.getTags?.forEach((element) {
        contag.add(element.toString());
      });
      scheduleref.set({
        "owner": FirebaseAuth.instance.currentUser!.email.toString().trim(),
        "name": nameController.text.trim(),
        "events": [],
        "member": [],
        "contributor": [],
        "permission": {
          "canedit": true,
          "caninvite": false,
          "canpermission": false,
          "candelete": false,
        },
        "personal": false,
      });
      var userdoc = FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid);

      userdoc.update({
        "shared": FieldValue.arrayUnion([scheduleref.id])
      });

      if (member.getTags!.isNotEmpty) {
        for (var i = 0; i < member.getTags!.length; i++) {
          for (var u = 0; u < user.length; u++) {
            if (member.getTags![i].toString() == user[u]["email"].toString()) {
              final emaildoc = FirebaseFirestore.instance
                  .collection("users")
                  .doc(user[u]["uid"].toString());

              //dev.log(user[i]["uid"].toString());
              final userdatainbox = <String, dynamic>{
                "email": FirebaseAuth.instance.currentUser!.email,
                "type": "member",
                "id": scheduleref.id,
                "name": nameController.text.trim()
              };
              emaildoc.update({
                "inbox": FieldValue.arrayUnion([userdatainbox])
              });
            }
          }
        }
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const SharedList()));
      }
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const SharedList()));
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
                  onPressed: create,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  const Row(children: [
                    Text("Schedule Name"),
                    //Text("Get your Schedule ID from the Admin"),
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                    controller: nameController,
                    hintText: 'Name',
                    obscureText: false,
                    error: errorstr,
                    isFilled: false,
                    padding: 0, border: true,

                    //errorText: _wrongemail ? "Wrong Email" : null,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Row(children: [
                    Text("Invite People to your Schedule"),
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
                      member.addTag = selectedTag;
                    },
                    fieldViewBuilder: (context, ttec, tfn, onFieldSubmitted) {
                      return TextFieldTags(
                        textEditingController: ttec,
                        focusNode: tfn,
                        textfieldTagsController: member,
                        initialTags: const [],
                        textSeparators: const [' ', ','],
                        letterCase: LetterCase.normal,
                        validator: (String tag) {
                          if (member.getTags!.contains(tag)) {
                            return 'you already entered that';
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
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      borderSide: BorderSide(
                                          width: 1.5,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inverseSurface
                                              .withOpacity(0.08))),
                                  errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 2.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    //<-- SEE HERE
                                    borderSide: BorderSide(
                                        width: 2,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inverseSurface
                                            .withOpacity(0.08)),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),

                                  //helperText: 'Enter language...',

                                  hintText: member.hasTags
                                      ? ''
                                      : "Enter Members email...",
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
                    height: 40,
                  ),
                  const Row(children: [
                    Text("Invite Contributors"),
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
                      contributor.addTag = selectedTag;
                    },
                    fieldViewBuilder: (context, ttec, tfn, onFieldSubmitted) {
                      return TextFieldTags(
                        textEditingController: ttec,
                        focusNode: tfn,
                        textfieldTagsController: contributor,
                        initialTags: const [],
                        textSeparators: const [' ', ','],
                        letterCase: LetterCase.normal,
                        validator: (String tag) {
                          if (contributor.getTags!.contains(tag)) {
                            return 'you already entered that';
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
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      borderSide: BorderSide(
                                          width: 1.5,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inverseSurface
                                              .withOpacity(0.08))),
                                  errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 2.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),

                                  //helperText: 'Enter language...',

                                  hintText: contributor.hasTags
                                      ? ''
                                      : "Enter Contributors email...",
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
                ]))));
  }
}
