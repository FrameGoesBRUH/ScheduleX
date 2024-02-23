import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schedulex/pages/auth/components/my_button.dart';
import 'package:schedulex/pages/auth/components/my_textfield.dart';
import 'package:schedulex/pages/auth/sent_email.dart';
import 'package:schedulex/size.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();

  var error;

  Future<void> sendemail() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const sentPassword()),
      );
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
                'Enter your email and we will send Password reset link through this email',
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
                error: error,
                isFilled: true,
                padding: 0,
                //errorText: _wrongemail ? "Wrong Email" : null,
              ),

              const SizedBox(height: 10),
              const SizedBox(height: 25),

              // sign in button
              MyButton(
                text: "Send Email",
                onTap: sendemail,
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
            ],
          ),
        ),
      ))),
    );
  }
}
