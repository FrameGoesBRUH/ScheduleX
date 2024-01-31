import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:schedulex/pages/home/home.dart';
import 'package:schedulex/pages/home/user_choice.dart';

class choice_Home extends StatefulWidget {
  const choice_Home({super.key});

  @override
  State<choice_Home> createState() => choice_HomeState();
}

class choice_HomeState extends State<choice_Home> {
  bool isnewuser = false;

  Future<void> getdata() async {
    final user = FirebaseAuth.instance.currentUser!;

    var docref = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .get();
    if (docref.exists) {
      Map<String, dynamic> data = docref.data()!;
      if (data['accounttype'].toString() == "null") {
        setState(() {
          isnewuser = true;
        });
      } else {
        setState(() {
          isnewuser = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    // Return the widgets.
    if (isnewuser) {
      return const UserChoice();
    } else {
      return HomePage();
    }
  }
}
