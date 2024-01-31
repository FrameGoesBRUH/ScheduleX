//import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:schedulex/Theme/light_Theme.dart';
import '../mainComponents/drawer.dart';
import '../mainComponents/baseAppBar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  //final user = FirebaseAuth.instance.currentUser!;

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const baseAppBar(),
      drawer: const DrawerNav(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: Container(
            width: (MediaQuery.of(context).size.width),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                    //height:
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: const BorderRadius.all(Radius.circular(40)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 15),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Schedule",
                                style: GoogleFonts.lato(
                                  fontSize: 30,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  //fontWeight: FontWeight.w600,
                                )),
                            const SizedBox(height: 4),
                            Text("12.00 - 13.10 pm.",
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  //fontWeight: FontWeight.w400,
                                )),
                            const SizedBox(height: 24),
                            Text("Mr.Frame",
                                style: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontWeight: FontWeight.w600,
                                )),
                            const SizedBox(height: 18),
                            Divider(
                              thickness: 1,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                            const SizedBox(height: 10),
                            Text("Note",
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontWeight: FontWeight.w400,
                                )),
                            const SizedBox(height: 4),
                            Text("Example note for design purpose only",
                                style: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  fontWeight: FontWeight.w400,
                                )),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          )),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              "Task",
              style: GoogleFonts.lato(
                color: Theme.of(context).colorScheme.inverseSurface,
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
