import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:schedulex/pages/schedules/components/schedule_Button.dart';
import 'package:schedulex/pages/schedules/join.dart';
import 'package:schedulex/pages/schedules/joinedschedulebase.dart';
import 'package:schedulex/provider/provider.dart';
import '../mainComponents/drawer.dart';
import '../mainComponents/baseAppBar.dart';

//List<String> list = <String>['Joined Schedules', 'joined Schedules'];

class JoinedList extends StatefulWidget {
  const JoinedList({super.key});

  @override
  State<JoinedList> createState() => _JoinedListState();
}

class _JoinedListState extends State<JoinedList> {
  List<dynamic> sharedlist = [];
  List<dynamic> sharedname = [];
  List<dynamic> sharedname2 = [];

  bool isLoaded = false;
  bool isNoschedule = false;

  Future<void> pushnav(int index) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => JoinedSchedule(
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
      isLoaded = false;
      //log("message");

      sharedlist = userdata['joined'];

      ////log(friendsList.toString());
      //friendsList = (value.data() as dynamic)["friends"];
      if (sharedlist.isNotEmpty) {
        setState(() {
          isNoschedule = false;
        });
        for (var i = 0; i < sharedlist.length; i++) {
          var shareddoc = await FirebaseFirestore.instance
              .collection("schedules")
              .doc(sharedlist[i])
              .get();

          if (shareddoc.exists) {
            Map<String, dynamic> shareddata = shareddoc.data()!;
            sharedname2.add(shareddata['owner'].toString());
            setState(() {
              if (shareddata['name'].toString() == "") {
                sharedname.add("untitle");
              } else {
                sharedname.add(shareddata['name'].toString());
              }
            });
          } else {
            var userdoc = FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid);

            userdoc.update({
              "shared": FieldValue.arrayRemove([sharedlist[i]])
            });
          }
        }
        setState(() {
          isLoaded = true;
        });
      } else {
        setState(() {
          isNoschedule = true;
        });
      }
    } else {
      setState(() {
        isLoaded = true;
      });

      final provider = Provider.of<EventProvider>(context, listen: false);
      provider.clearEvent();
    }
  }

  var docref = FirebaseFirestore.instance.collection('users').get();
  //Map<String, dynamic> data = docref.()!
  @override
  void initState() {
    super.initState();
    getclass();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const baseAppBar(),
      drawer: const DrawerNav(),
      body: Container(
          child: isLoaded
              ? ListView.builder(
                  itemCount: sharedlist.length,
                  itemBuilder: (context, index) => Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: MyschButton(
                        onTap: () => pushnav(index),
                        text: sharedname[index],
                        text2: sharedname2[index],
                      )),
                )
              : Center(
                  child: isNoschedule
                      ? const Text("No shcedule joined")
                      : const Text("Loading"))

          //margin: const EdgeInsets.symmetric(horizontal: 20),
          ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const join())),
      ),
    );
  }
}
