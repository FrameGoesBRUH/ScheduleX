import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: Color.fromARGB(255, 0, 0, 0),
    primary: Color.fromARGB(255, 245, 147, 57),
    secondary: Color.fromARGB(35, 255, 255, 255),
    tertiary: Color.fromARGB(255, 168, 168, 168),
    inverseSurface: Colors.white,
    inversePrimary: Colors.white,
  ),
// ColorScheme.light
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 18, color: Colors.white),
    bodySmall:
        TextStyle(fontSize: 14, color: Color.fromARGB(255, 158, 158, 158)),
    displaySmall:
        TextStyle(fontSize: 14, color: Color.fromARGB(255, 255, 255, 255)),
  ),
); // ThemeData
//var primaryColor = const Color.fromARGB(255, 255, 145, 77);
