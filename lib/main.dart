// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:schedulex/pages/auth/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:schedulex/pages/auth/login_register.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginRegister(),
    );
  }
}
