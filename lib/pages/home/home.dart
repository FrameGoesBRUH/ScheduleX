import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedulex/color.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              "Now",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
              child: Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(50, 0, 0, 0),
                  blurRadius: 25.0,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                    height: 200,
                    width: 350,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 15),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Schedule",
                                style: GoogleFonts.poppins(
                                  fontSize: 35,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                )),
                            Text("12.00 - 13.10 pm.",
                                style: GoogleFonts.poppins(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                )),
                            const SizedBox(height: 18),
                            Text("Mr.Frame",
                                style: GoogleFonts.poppins(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                )),
                          ],
                        ),
                      ),
                    )),
                Container(
                    height: 150,
                    width: 350,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 15),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Note",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                )),
                            Text("Example note for design purpose only",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                )),
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
              "Next",
              style: GoogleFonts.poppins(
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
