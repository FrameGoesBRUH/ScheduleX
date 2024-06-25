//import 'dart:ffi';

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final controller;
  final String hintText;
  final bool obscureText;
  final dynamic error;
  final double padding;
  final bool isFilled;
  final bool border;

  const MyTextField(
      {super.key,
      required this.border,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      required this.error,
      required this.isFilled,
      required this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: TextField(
          controller: controller,
          obscureText: obscureText,
          style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                    width: 1.5,
                    color: border
                        ? Theme.of(context)
                            .colorScheme
                            .inverseSurface
                            .withOpacity(0.08)
                        : Colors.transparent)),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedBorder: OutlineInputBorder(
              //<-- SEE HERE
              borderSide: BorderSide(
                  width: 3, color: Theme.of(context).colorScheme.secondary),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            errorText: error,
            //labelText: TextStyle(Theme.of(context).textTheme.bodySmall),
            fillColor: Theme.of(context).colorScheme.secondary,
            filled: isFilled,
            hintText: hintText,
            hintStyle: TextStyle(
              color:
                  Theme.of(context).colorScheme.inverseSurface.withAlpha(100),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          )),
    );
  }
}
