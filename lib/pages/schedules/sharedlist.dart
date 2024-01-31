import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:schedulex/pages/schedules/joinedschedulebase.dart';
import 'package:schedulex/pages/schedules/sharedschedulebase.dart';
import '../mainComponents/drawer.dart';
import '../mainComponents/baseAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'components/schedule_Button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SharedList extends StatefulWidget {
  const SharedList({super.key});

  @override
  State<SharedList> createState() => _SharedListState();
}

class _SharedListState extends State<SharedList> {
  List<dynamic> sharedlist = [];
  List<dynamic> sharedname = [];

  @override
  void initState() {
    super.initState();
    getclass();
  }

  Future<void> pushnav(int index) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SharedSchedule(
                  id: sharedlist[index],
                  name: sharedname[index],
                )));
  }

  Future<void> getclass() async {
    //log(FirebaseAuth.instance.currentUser!.uid);
    var userdoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (userdoc.exists) {
      Map<String, dynamic> userdata = userdoc.data()!;

      //log("message");
      setState(() {
        sharedlist = userdata['shared'];

        ////log(friendsList.toString());
        //friendsList = (value.data() as dynamic)["friends"];
      });

      for (var i = 0; i < sharedlist.length; i++) {
        var shareddoc = await FirebaseFirestore.instance
            .collection("schedules")
            .doc(sharedlist[i])
            .get();
        setState(() {
          if (shareddoc.exists) {
            Map<String, dynamic> shareddata = shareddoc.data()!;

            sharedname.add(shareddata['name'].toString());
          } else {
            sharedname.add('Untitled');
          }
        });
      }
    }
  }

  var docref = FirebaseFirestore.instance.collection('users').get();
  //Map<String, dynamic> data = docref.()!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: const baseAppBar(),
        drawer: const DrawerNav(),
        body: Container(
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    if (sharedname.isNotEmpty) {
                      return ListView.builder(
                        itemCount: sharedlist.length,
                        itemBuilder: (context, index) => Container(
                            padding: const EdgeInsets.all(10),
                            child: MyschButton(
                              onTap: () => pushnav(index),
                              text: sharedname[index],
                            )),
                      );
                    } else {
                      return Text("Loading");
                    }
                  } else {
                    return Text("Loading");
                  }

                  //margin: const EdgeInsets.symmetric(horizontal: 20),
                })));
  }
}
