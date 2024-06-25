import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedulex/pages/auth/auth_page.dart';
import 'package:schedulex/pages/calendar/calendar.dart';
import 'package:schedulex/pages/home/home.dart';
import 'package:schedulex/pages/schedules/inbox.dart';
import 'package:schedulex/pages/schedules/joinedlist.dart';
import 'package:schedulex/pages/schedules/sharedlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:schedulex/provider/provider.dart';
//import 'dart:developer' as dev;

class DrawerNav extends StatelessWidget {
  const DrawerNav({super.key});

  Future<void> signUserOut() async {
    //dev.log("aa");
    await FirebaseAuth.instance.signOut();
    //dev.log(FirebaseAuth.instance.currentUser!.uid.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Schedule X',
                      style: TextStyle(fontSize: 25),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(FirebaseAuth.instance.currentUser!.email.toString()),
                    Switch(
                        value: Provider.of<EventProvider>(context).isDarkMode,
                        onChanged: (value) {
                          final provider = Provider.of<EventProvider>(context,
                              listen: false);
                          provider.toggleTheme(value);
                        }),
                  ])),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              // Update the state of the app
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomePage()));
              // Then close the drawer
              //Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Calendar'),
            onTap: () {
              // Update the state of the app
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CalendarPage(
                        date: DateTime.now(),
                      )));
              // Then close the drawer
              //Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Joined Schedules'),
            onTap: () {
              // Update the state of the app
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const JoinedList()));
              // Then close the drawer/
              //Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Shared Schedules'),
            onTap: () {
              // Update the state of the app
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SharedList()));
              // Then close the drawer/
              //Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Mail'),
            onTap: () {
              // Update the state of the app
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const Inbox()));
              // Then close the drawer/
              //Navigator.pop(context);
            },
          ),
          const SizedBox(
            height: 50,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                signUserOut();
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
