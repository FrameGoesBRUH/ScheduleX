import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schedulex/pages/home/choice_home.dart';
//import '../home/home.dart';
import 'login_register.dart';
//import 'home_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return const choice_Home();
          }

          // user is NOT logged in
          else {
            return const LoginRegister();
          }
        },
      ),
    );
  }
}
