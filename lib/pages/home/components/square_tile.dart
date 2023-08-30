import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  final String text;
  const SquareTile({
    super.key,
    required this.imagePath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 250,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
        elevation: 6,
        color: Colors.white,
        semanticContainer: true,
        // Implement InkResponse
        child: InkResponse(
          containedInkWell: true,
          highlightShape: BoxShape.rectangle,

          // Add image & text
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Ink.image(
                  height: 170, fit: BoxFit.cover, image: AssetImage(imagePath)),
              Text(
                text,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40)
            ],
          ),
        ),
      ),
    );
  }
}
