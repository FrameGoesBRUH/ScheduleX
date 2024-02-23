import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';

class MyschButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final String text2;
  const MyschButton(
      {super.key,
      required this.onTap,
      required this.text,
      required this.text2});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlowContainer(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        color: Theme.of(context).colorScheme.secondary,
        blurRadius: 20,
        borderRadius: BorderRadius.circular(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            text2,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          )
        ]),
      ),
    );
  }
}
