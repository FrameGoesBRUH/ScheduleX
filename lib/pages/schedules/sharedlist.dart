import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedulex/pages/schedules/components/schedule_Button.dart';
import 'package:schedulex/pages/schedules/create.dart';
import 'package:schedulex/pages/schedules/sharedschedulebase.dart';
import 'package:schedulex/provider/provider.dart';
import '../mainComponents/drawer.dart';
import '../mainComponents/baseAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SharedList extends StatefulWidget {
  const SharedList({super.key});

  @override
  State<SharedList> createState() => _SharedListState();
}

class _SharedListState extends State<SharedList> {
  List<dynamic> sharedlist = [];
  List<dynamic> sharedname = [];
  List<dynamic> sharedname2 = [];

  bool isLoaded = false;
  bool isNoschedule = false;

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
                  name2: sharedname2[index],
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

      sharedlist = userdata['shared'];

      ////log(friendsList.toString());
      //friendsList = (value.data() as dynamic)["friends"];
      if (sharedlist.isNotEmpty) {
        setState(() {
          isNoschedule = false;
        });
        //dev.log(sharedlist.length.toString());
        for (var i = 0; i < sharedlist.length; i++) {
          var shareddoc = await FirebaseFirestore.instance
              .collection("schedules")
              .doc(sharedlist[i])
              .get();
          setState(() {
            if (shareddoc.exists) {
              Map<String, dynamic> shareddata = shareddoc.data()!;
              sharedname2.add(sharedlist[i].toString());
              setState(() {
                if (shareddata['name'].toString() == "") {
                  sharedname.add("untitle");
                } else {
                  sharedname.add(shareddata['name'].toString());
                }
              });
            }
          });
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
              .push(MaterialPageRoute(builder: (context) => const create()))),
    );
  }
}
