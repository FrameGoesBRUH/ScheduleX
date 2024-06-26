import 'package:flutter/material.dart';
import 'components/textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class join extends StatefulWidget {
  const join({super.key});

  @override
  State<join> createState() => _joinState();
}

class _joinState extends State<join> {
  final idController = TextEditingController();
  var errorstr;
  Future join() async {
    if (idController.text.isEmpty) {
      setState(() {
        errorstr = "You need to enter the code";
      });
    } else {
      var schedule = await FirebaseFirestore.instance
          .collection("schedules")
          .doc(idController.text.trim().toString())
          .get();

      if (schedule.exists) {
        var userdoc = FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid);
        var scheduledoc = FirebaseFirestore.instance
            .collection("schedules")
            .doc(idController.text.trim().toString());
        scheduledoc.update({
          "member": FieldValue.arrayUnion([
            {
              "email": FirebaseAuth.instance.currentUser!.email.toString(),
              "uid": FirebaseAuth.instance.currentUser!.uid.toString()
            }
          ])
        });
        userdoc.update({
          "joined": FieldValue.arrayUnion([idController.text])
        });
      } else {
        setState(() {
          errorstr = "Schedule not found";
        });
      }
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
                  onPressed: join,
                  icon: Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                ),
              ])
            ]),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Text(
                    "Schedule ID",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inverseSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),
                  Text(
                    "Get your Schedule ID from the Admin",
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .inverseSurface
                          .withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                    controller: idController,
                    hintText: 'Schedule id',
                    obscureText: false,
                    error: errorstr,
                    isFilled: false,
                    padding: 0, border: true,

                    //errorText: _wrongemail ? "Wrong Email" : null,
                  ),
                ]))));
  }
}
