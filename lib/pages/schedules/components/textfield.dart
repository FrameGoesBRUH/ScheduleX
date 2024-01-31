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

  const MyTextField(
      {super.key,
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
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(width: 3, color: Colors.transparent)),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            focusedBorder: const OutlineInputBorder(
              //<-- SEE HERE
              borderSide: BorderSide(width: 3, color: Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            errorText: error,
            //labelText: TextStyle(Theme.of(context).textTheme.bodySmall),
            fillColor: Theme.of(context).colorScheme.secondary,
            filled: isFilled,
            hintText: hintText,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.inverseSurface.withAlpha(50),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          )),
    );
  }
}
