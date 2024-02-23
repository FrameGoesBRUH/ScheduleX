// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedulex/Theme/dark_Theme.dart';
import 'package:schedulex/Theme/light_Theme.dart';
import 'package:schedulex/local_notifications.dart';
import 'package:schedulex/pages/auth/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:schedulex/pages/auth/login_register.dart';
import 'package:schedulex/pages/calendar/calendar.dart';
import 'package:schedulex/pages/home/home.dart';
//import 'package:schedulex/pages/home/user_choice.dart';
import 'package:schedulex/pages/schedules/eventedit.dart';
import 'package:schedulex/pages/schedules/joinedlist.dart';
import 'package:schedulex/provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.innit();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
      create: (context) => EventProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<EventProvider>(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        darkTheme: darkMode,
        themeMode: themeProvider.themeMode,
        home: const AuthPage());
  }
}
