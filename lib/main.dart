import 'package:flutter/material.dart';
import 'package:movie_app/colors.dart';
import 'package:movie_app/screens/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MOVIES",
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColours.primaryBgColor,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
