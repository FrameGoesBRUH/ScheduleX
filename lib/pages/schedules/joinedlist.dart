import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:schedulex/pages/schedules/joinedschedulebase.dart';
import '../mainComponents/drawer.dart';
import '../mainComponents/baseAppBar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'components/schedule_Button.dart';

//List<String> list = <String>['Joined Schedules', 'joined Schedules'];

class JoinedList extends StatefulWidget {
  const JoinedList({super.key});

  @override
  State<JoinedList> createState() => _JoinedListState();
}

class _JoinedListState extends State<JoinedList> {
  List<dynamic> joinedlist = [];
  List<dynamic> joinedname = [];
  //String dropdownValue = list.first;
  void initState() {
    super.initState();
    getclass();
  }

  Future<void> pushnav() async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const JoinedSchedule()));
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
        joinedlist = userdata['joined'];

        ////log(friendsList.toString());
        //friendsList = (value.data() as dynamic)["friends"];
      });

      for (var i = 0; i < joinedlist.length; i++) {
        var joineddoc = await FirebaseFirestore.instance
            .collection("schedules")
            .doc(joinedlist[i])
            .get();
        setState(() {
          if (joineddoc.exists) {
            Map<String, dynamic> joineddata = joineddoc.data()!;

            joinedname.add(joineddata['name'].toString());
          } else {
            joinedname.add('Untitled');
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: const baseAppBar(),
        drawer: const DrawerNav(),
        body: Container(
            //margin: const EdgeInsets.symmetric(horizontal: 20),
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) => Container(
                          padding: const EdgeInsets.all(10),
                          child: MyschButton(
                            onTap: pushnav,
                            text: snapshot.data!.docs[index]['email'],
                          )),
                    );
                  } else {
                    return Container();
                  }
                })));
  }
}
