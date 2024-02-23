import 'package:flutter/material.dart';

class MemberButton extends StatelessWidget {
  final String text;
  final String uid;
  const MemberButton({
    super.key,
    required this.text,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color:
                Theme.of(context).colorScheme.inverseSurface.withOpacity(0.2),
            width: 2.0,
          ),
        ),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        const Icon(Icons.people),
        const SizedBox(
          width: 10,
        ),
        Text(
          text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.inverseSurface,
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ]),
    );
  }
}
