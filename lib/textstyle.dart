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
      primary: Colors.blueGrey.shade900,
      secondary: Colors.blueGrey.shade500,
      primaryContainer: Colors.blueGrey.shade700,
      secondaryContainer: Colors.blueGrey.shade400,
      error: Colors.red,

      // ? SURFACE ? //
      surface: Colors.blueGrey.shade900,
      background: Colors.blueGrey.shade600,

      // ? ON ? //
      onPrimary: Colors.white,
      onPrimaryContainer: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.blueGrey.shade400,
      onBackground: Colors.blueGrey.shade400,
      onError: Colors.black,
      brightness: Brightness.light),
);


// ! TODO ! //
// ? Régler le fait que la page princpale ne s'affiche pas --> setstate()?
// ? Rendre utilisable les propositions de questions à poser
// ? Créer manuellement le thème graphique de l'application
