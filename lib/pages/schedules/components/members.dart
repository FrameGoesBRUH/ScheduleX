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
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inverseSurface.withOpacity(.07),
        border: Border.all(
          color: Colors.transparent,
          width: 0.4, //                   <--- border width here
        ),
        borderRadius: const BorderRadius.all(Radius.circular(50.0)),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        const SizedBox(
          width: 10,
        ),
        const Icon(
          Icons.people,
          size: 20,
        ),
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
