import 'package:flutter/material.dart';
import 'package:schedulex/pages/calendar/calendar.dart';
import 'package:schedulex/pages/home/home.dart';

class DrawerNav extends StatelessWidget {
  const DrawerNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Text('Schedule X'),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              // Update the state of the app
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomePage()));
              // Then close the drawer
              //Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Calendar'),
            onTap: () {
              // Update the state of the app
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CalendarPage()));
              // Then close the drawer
              //Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('School'),
            onTap: () {
              // Update the state of the app
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomePage()));
              // Then close the drawer/
              //Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
