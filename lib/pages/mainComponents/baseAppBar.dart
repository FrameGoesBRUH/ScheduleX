import 'package:flutter/material.dart';
import 'package:schedulex/pages/calendar/calendar.dart';
import 'package:schedulex/pages/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          IconButton(
            onPressed: null,
            icon: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
          ),
          IconButton(
            onPressed: signUserOut,
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
          ),
        ]);
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(60.0);
}
