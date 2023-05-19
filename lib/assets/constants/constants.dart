import 'package:flutter/material.dart';

TextStyle normalText = const TextStyle(
  color: Colors.white,
  fontSize: 15,
  fontWeight: FontWeight.w300,
);

TextStyle titleText = const TextStyle(
  color: Colors.white,
  fontSize: 40,
  fontWeight: FontWeight.w700,
);

TextStyle titleText2 = const TextStyle(
  color: Colors.white,
  fontSize: 20,
  fontWeight: FontWeight.w500,
);

ThemeData themeApp = ThemeData(
  colorScheme: ColorScheme(

      // ? PRIMAIRES ? //
      primary: const Color(0xFF444654), // responses
      secondary: const Color(0xFF343541), // questions, text Field and appBar
      primaryContainer: const Color(0xFF202123), // drawer
      secondaryContainer: const Color(0xFF3E3F4B), //Question grid
      error: Colors.red,

      // ? SURFACE ? //
      surface: Colors.blueGrey.shade900,
      background: const Color(0xFF444654), // like responses

      // ? ON ? //
      onPrimary: Colors.white,
      onPrimaryContainer: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.white,
      brightness: Brightness.dark),
);
