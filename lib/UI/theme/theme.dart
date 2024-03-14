import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const double titleFontSize = 25;

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        foregroundColor: Colors.black,
        titleTextStyle:
            GoogleFonts.aBeeZee(fontSize: titleFontSize, color: Colors.black)),
    colorScheme: ColorScheme.light(
      background: Colors.grey.shade200,
      primary: Colors.black,
    ),
    textTheme: GoogleFonts.aBeeZeeTextTheme(
        ThemeData(brightness: Brightness.light)
            .textTheme
            .copyWith(bodySmall: const TextStyle(color: Colors.black38))));

ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        titleTextStyle:
            GoogleFonts.aBeeZee(fontSize: titleFontSize, color: Colors.white)),
    colorScheme: ColorScheme.dark(
      background: Colors.grey.shade900,
      primary: Colors.white60,
      secondary: Colors.grey.shade700,
    ),
    bottomAppBarTheme:
        const BottomAppBarTheme().copyWith(color: Colors.transparent),
    textTheme: GoogleFonts.aBeeZeeTextTheme(
        ThemeData(brightness: Brightness.dark)
            .textTheme
            .copyWith(bodySmall: const TextStyle(color: Colors.white38))));
