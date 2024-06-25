// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_glow/flutter_glow.dart';
//import 'package:schedulex/pages/auth/auth_service.dart';
import 'package:schedulex/pages/auth/components/my_button.dart';
import 'package:schedulex/pages/auth/components/my_textfield.dart';
import 'package:schedulex/pages/home/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schedulex/size.dart';

//import '../model/user.dart' as model;

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  //authService authPage = authService();
  bool _unmatchpass = false;

  // sign user in method
  Future<void> signUserUp() async {
    // show loading circle

    // try sign in
    try {
      if (passwordController.text.trim() ==
          confirmPasswordController.text.trim()) {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        )
            .then((value) {
          //final docs = await FirebaseFirestore.instance.collection("users");
          //authPage.storeTokenAndData(value);
          addUserDetails();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        });
      } else {
        setState(() {
          _unmatchpass = true;
        });
      }
    } on FirebaseAuthException catch (e) {
      showError(e.code);
    }
  }

  Future<void> addUserDetails() async {
    final scheduleref =
        FirebaseFirestore.instance.collection("schedules").doc();
    scheduleref.set({
      "owner": emailController.text.trim(),
      "name": "Personal Schedule",
      "events": [],
      "member": [],
      "contributor": [],
      "personal": true,
      "permission": {
        "canedit": true,
        "caninvite": false,
        "canpermission": false,
        "candelete": false,
      }
    }).then((value) => value);
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "email": emailController.text.trim(),
      "joined": [],
      "shared": [scheduleref.id],
      "inbox": [],
    });
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  showTextError(String message) {
    if (message == "unmatchpass") {
      if (_unmatchpass == true) {
        return "Unmatch Password";
      } else {
        return null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
            child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Container(
                constraints: BoxConstraints(
                    maxWidth:
                        displayHeight(context) + displayWidth(context) * 0.1),
                padding: EdgeInsets.symmetric(
                    horizontal: displayWidth(context) * 0.05),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),

                    // logo
                    GlowIcon(
                      Icons.lock,
                      color: Theme.of(context).colorScheme.primary,
                      size: 100,
                      blurRadius: 40,
                      glowColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.5),
                    ),

                    const SizedBox(height: 30),

                    // welcome back, you've been missed!
                    Text(
                      'Let\'s create your account!',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // email textfield
                    MyTextField(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                      error: null,
                      isFilled: false,
                      padding: 0,
                    ),

                    const SizedBox(height: 10),

                    // password textfield
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .inverseSurface
                                  .withOpacity(0.08),
                              width: 1.5),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent,
                        ),
                        child: Column(children: [
                          MyTextField(
                            controller: passwordController,
                            hintText: 'Password',
                            obscureText: true,
                            error: null,
                            isFilled: null,
                            padding: 0,
                          ),
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey[400],
                              )),
                          //const SizedBox(height: 10),
                          MyTextField(
                            controller: confirmPasswordController,
                            hintText: 'Confirm Password',
                            obscureText: true,
                            error: showTextError("unmatchpass"),
                            isFilled: null,
                            padding: 0,
                          )
                        ])),

                    const SizedBox(height: 25),

                    // sign in button
                    MyButton(
                      text: "Sign Up",
                      onTap: signUserUp,
                    ),

                    const SizedBox(height: 30),

                    // or continue with
                    /*
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Or continue with',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // google + apple sign in buttons
                    
                    GestureDetector(
                      onTap: signInWithGoogle,
                      child: Container(
                          // margin: EdgeInsets.all(10),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            // border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(16),
                            color: Theme.of(context)
                                .colorScheme
                                .inverseSurface
                                .withOpacity(.2),
                          ),
                          height: 50,
                          child: Row(
                            children: [
                              Image.asset(
                                'lib/images/google.png',
                                height: 20,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Continue with Google",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 18),
                              )
                            ],
                          )),
                    ),*/
                    const SizedBox(height: 15),

                    // not a member? register now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inverseSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        )));
  }
}
