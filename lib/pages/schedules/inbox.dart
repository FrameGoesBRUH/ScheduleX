import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:schedulex/pages/schedules/components/inbox_Button.dart';
import '../mainComponents/drawer.dart';

class Inbox extends StatefulWidget {
  const Inbox({super.key});

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  bool isLoaded = false;
  List<dynamic> inboxlist = [];
  List<Map> inbox = [];
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

      inboxlist = userdata["inbox"];

      ////log(friendsList.toString());
      //friendsList = (value.data() as dynamic)["friends"];
      if (inboxlist.isNotEmpty) {
        for (var i = 0; i < inboxlist.length; i++) {
          Map<String, dynamic> inboxdata = inboxlist[i];
          inbox.add({
            "email": inboxdata["email"],
            "name": inboxdata["name"],
            "id": inboxdata["id"],
            "type": inboxdata["type"],
          });
        }
        setState(() {
          isLoaded = true;
        });
      } else {
        setState(() {
          isLoaded = false;
        });
      }
    }
  }

  Future<void> joininbox(int index) async {
    var userdoc = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid);

    final scheduleref = FirebaseFirestore.instance
        .collection("schedules")
        .doc(inbox[index]["id"]);
    if (inbox[index]["type"] == "member") {
      userdoc.update({
        "joined": FieldValue.arrayUnion([inbox[index]["id"].toString()])
      });
      scheduleref.update({
        "member": FieldValue.arrayUnion([
          {
            "email": FirebaseAuth.instance.currentUser!.email.toString(),
            "uid": FirebaseAuth.instance.currentUser!.uid.toString()
          }
        ])
      });
    } else {
      userdoc.update({
        "shared": FieldValue.arrayUnion([inbox[index]["id"].toString()])
      });
      scheduleref.update({
        "contributor": FieldValue.arrayUnion([
          {
            "email": FirebaseAuth.instance.currentUser!.email.toString(),
            "uid": FirebaseAuth.instance.currentUser!.uid.toString()
          }
        ])
      });
    }
    userdoc.update({
      "inbox": FieldValue.arrayRemove([
        {
          "email": inbox[index]["email"],
          "name": inbox[index]["name"],
          "id": inbox[index]["id"],
          "type": inbox[index]["type"],
        }
      ])
    });
    setState(() {
      inbox.removeAt(index);
      if (inbox.isEmpty) {
        isLoaded = false;
      }
    });
  }

  Future<void> deleteinbox(int index) async {
    var userdoc = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid);

    userdoc.update({
      "inbox": FieldValue.arrayRemove([
        {
          "email": inbox[index]["email"],
          "name": inbox[index]["name"],
          "id": inbox[index]["id"],
          "type": inbox[index]["type"],
        }
      ])
    });
    setState(() {
      inbox.removeAt(index);
      if (inbox.isEmpty) {
        isLoaded = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    getclass();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.inverseSurface),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.close,
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
          ),
        ],
      ),
      drawer: const DrawerNav(),
      body: Container(
          child: isLoaded
              ? ListView.builder(
                  itemCount: inbox.length,
                  itemBuilder: (context, index) => Container(
                      padding: const EdgeInsets.all(10),
                      child: InboxButton(
                        onTap: () => joininbox(index),
                        onTap2: () => deleteinbox(index),
                        text:
                            "You've got an invite to be the ${inbox[index]["type"]} of ${inbox[index]["name"]}",
                        text2: inbox[index]["email"],
                      )),
                )
              : const Center(child: Text("No Inbox"))

          //margin: const EdgeInsets.symmetric(horizontal: 20),
          ),
    );
  }
}
