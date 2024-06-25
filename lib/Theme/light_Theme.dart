import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: Colors.white,
    primary: Color.fromARGB(255, 245, 147, 57),
    secondary: Color.fromARGB(255, 245, 147, 57),
    tertiary: Colors.white,
    surface: Color.fromARGB(255, 245, 147, 57),
    inversePrimary: Colors.white,
    inverseSurface: Colors.black,
  ),
// ColorScheme.light
  textTheme: ThemeData.light().textTheme.apply(
        bodyColor: Colors.grey[800],
        displayColor: Colors.black,
      ),
); // ThemeData
var primaryColor = const Color.fromARGB(255, 255, 145, 77);
