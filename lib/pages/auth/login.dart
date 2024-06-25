// ignore_for_file: use_build_context_synchronously, unused_import

//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:schedulex/pages/auth/auth_service.dart';
import 'package:schedulex/pages/auth/components/my_button.dart';
import 'package:schedulex/pages/auth/components/my_textfield.dart';
import 'package:schedulex/pages/auth/components/square_tile.dart';
import 'package:schedulex/pages/auth/forgot_password.dart';
import 'package:schedulex/pages/home/home.dart';
import 'package:schedulex/size.dart';
import 'auth_page.dart';
//import 'dart:developer' as d;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_glow/flutter_glow.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // authService authPage = new authService();
  var errortext;

  // sign user in method
  Future<void> signUserIn() async {
    // try sign in
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
          .then((credential) async {
        //d.log(credential.toString());
        //authPage.storeTokenAndData(credential);
        // Obtain shared preferences
        //d.log(email.toString());
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
        //debugPrint('ygg');

        /*if (docref.exists) {
          Map<String, dynamic> data = docref.data()!;

          debugPrint(data['accounttype'].toString());
          if (data['accounttype'].toString() == "null") {
            debugPrint('kfn');
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const UserChoice()));
          } else {
            debugPrint('jgh');
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const UserChoice()));
          }
        }*/
      });
      // pop the loading circle
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      // WRONG EMAIL
      if (e.code == 'user-not-found') {
        // show error to user
        setState(() {
          errortext = "User not found. Try changing the Email";
        });
      }
      if (e.code == 'user-not-found') {
        // show error to user
        setState(() {
          errortext = "User not found. Try changing the Email";
        });
      }

      // WRONG PASSWORD
      else if (e.code == 'wrong-password') {
        // show error to user
        setState(() {
          errortext = "Wrong Password";
        });
      } else {
        setState(() {
          errortext = e.code.toString();
        });
      }
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

              GlowIcon(
                Icons.lock,
                color: Theme.of(context).colorScheme.primary,
                size: 100,
                blurRadius: 40,
                glowColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),

              const SizedBox(height: 50),

              // welcome back, you've been missed!
              const Text(
                'Welcome back, you\'ve been missed!',
                style: TextStyle(
                  //color: Theme.of(context).textTheme.displayLarge,
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
                //errorText: _wrongemail ? "Wrong Email" : null,
              ),

              const SizedBox(height: 10),

              // password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
                error: errortext,
                isFilled: false,
                padding: 0,
                //errorText: _wrongpassword ? 'Wrong Password' : null,
              ),

              const SizedBox(height: 10),

              // forgot password?
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ForgotPassword()),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // sign in button
              MyButton(
                text: "Sign In",
                onTap: signUserIn,
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
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
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

              const SizedBox(height: 30),

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
              ),
*/
              const SizedBox(height: 30),

              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inverseSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      'Register now',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ))),
    );
  }
}
