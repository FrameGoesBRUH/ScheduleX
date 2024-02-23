import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schedulex/pages/auth/components/my_button.dart';
import 'package:schedulex/pages/auth/login_register.dart';
import 'package:schedulex/size.dart';

class sentPassword extends StatefulWidget {
  const sentPassword({super.key});

  @override
  State<sentPassword> createState() => _sentPasswordState();
}

class _sentPasswordState extends State<sentPassword> {
  final emailController = TextEditingController();

  var error;

  Future<void> sendemail() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
          child: SingleChildScrollView(
              child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Container(
          constraints: BoxConstraints(
              maxWidth: displayHeight(context) + displayWidth(context) * 0.1),
          padding:
              EdgeInsets.symmetric(horizontal: displayWidth(context) * 0.05),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              // logo

              const SizedBox(height: 50),

              // welcome back, you've been missed!
              const Text(
                "We've sent you the email. Check your email.",
                style: TextStyle(
                  //color: Theme.of(context).textTheme.displayLarge,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 50),
              // sign in button
              MyButton(
                text: "Back to Login",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginRegister()),
                ),
              ),

              // not a member? register now
            ],
          ),
        ),
      ))),
    );
  }
}
