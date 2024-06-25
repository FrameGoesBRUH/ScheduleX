import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';

class InboxButton extends StatelessWidget {
  final Function()? onTap;
  final Function()? onTap2;
  final String text;
  final String text2;
  const InboxButton(
      {super.key,
      required this.onTap,
      required this.onTap2,
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
              fontSize: 20,
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: onTap2,
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: onTap,
                child: const Text(
                  'Accept',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
