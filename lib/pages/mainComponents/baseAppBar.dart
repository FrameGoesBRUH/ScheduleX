import 'dart:math';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:schedulex/pages/schedules/inbox.dart';

class baseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const baseAppBar({super.key});
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.inverseSurface),
        elevation: 0,
        backgroundColor:
            Theme.of(context).colorScheme.background.withOpacity(.5),
        actions: [
          IconButton(
            onPressed: () {
              // Update the state of the app
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const Inbox()));
              // Then close the drawer/
            },
            icon: Icon(
              Icons.mail,
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
          ),
        ]);
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(60.0);
}
