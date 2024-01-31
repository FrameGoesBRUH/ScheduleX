// ignore_for_file: use_build_context_synchronously, unused_import

//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:schedulex/pages/auth/components/my_button.dart';
import 'package:schedulex/pages/auth/components/my_textfield.dart';
import 'package:schedulex/pages/auth/components/square_tile.dart';
import 'package:schedulex/pages/home/home.dart';
import 'package:schedulex/pages/home/user_choice.dart';
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

  var errortext = null;

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
        setState(() {});
        var docref = await FirebaseFirestore.instance
            .collection('users')
            .doc(emailController.text.trim())
            .get();

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

  // wrong password message popup
  /*showError(String message) {
    if (message == "checkemail") {
      if (_wrongemail == true) {
        return "Wrong Email";
      } else {
        return null;
      }
    } else if (message == "checkpass") {
      if (_wrongpassword == true) {
        return "Wrong Password";
      } else {
        return null;
      }
    } else {
      return null;
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
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
              ),

              const SizedBox(height: 50),

              // welcome back, you've been missed!
              const Text(
                'Welcome back you\'ve been missed!',
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
                isFilled: true,
                padding: 25,
                //errorText: _wrongemail ? "Wrong Email" : null,
              ),

              const SizedBox(height: 10),

              // password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
                error: errortext,
                isFilled: true,
                padding: 25,
                //errorText: _wrongpassword ? 'Wrong Password' : null,
              ),

              const SizedBox(height: 10),

              // forgot password?
              Padding(
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

              const SizedBox(height: 25),

              // sign in button
              MyButton(
                text: "Sign In",
                onTap: signUserIn,
              ),

              const SizedBox(height: 30),

              // or continue with
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // google button
                  SquareTile(imagePath: 'lib/images/google.png'),

                  SizedBox(width: 25),

                  // apple button
                  SquareTile(imagePath: 'lib/images/apple.png')
                ],
              ),

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
      ),
    );
  }
}
