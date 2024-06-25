import 'package:flutter/material.dart';

class Memberedit extends StatelessWidget {
  final String text;
  final String uid;
  final Function() onTap;
  const Memberedit({
    super.key,
    required this.text,
    required this.uid,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      //color: Colors.transparent,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color:
                Theme.of(context).colorScheme.inverseSurface.withOpacity(0.2),
            width: .4,
          ),
        ),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          const Icon(
            Icons.people,
            size: 17,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inverseSurface,
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ]),
        IconButton(
          onPressed: onTap,
          icon: const Icon(
            Icons.cancel_rounded,
            size: 18,
          ),
        )
      ]),
    );
  }
}
