import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:schedulex/pages/home/components/square_tile.dart';
import 'package:google_fonts/google_fonts.dart';

class UserChoice extends StatefulWidget {
  const UserChoice({super.key});

  @override
  State<UserChoice> createState() => _UserChoiceState();
}

class _UserChoiceState extends State<UserChoice> {
  final docRef =
      FirebaseFirestore.instance.collection("objects").doc("some-id");

  Future addUserDetails(String actype) async {
    await FirebaseFirestore.instance.collection("users").add({
      'accounttype': actype,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          IconButton(
            onPressed: null,
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          const SizedBox(height: 20),
          Text(
            'Are You ?',
            style: GoogleFonts.poppins(
              fontSize: 40,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              // Clear all showing snack bars
              addUserDetails("Admin");
            },
            child: const SquareTile(
              imagePath: 'lib/images/employer.png',
              text: "Admin",
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'OR',
            style: GoogleFonts.poppins(
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
              onTap: () {
                addUserDetails("Controller");
              },
              child: const SquareTile(
                  imagePath: 'lib/images/user.png', text: "User")),
        ]),
      ),
    );
  }
}
