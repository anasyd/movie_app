import 'package:flutter/material.dart';
import 'package:movie_app/bottom_navigator.dart';
import 'package:movie_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(
        isDarkMode: prefs.getBool("isDarkTheme") ?? true,
      ),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return MaterialApp(
        title: 'MovieDB',
        theme: themeProvider.getTheme,
        home: const AppBottomBar(),
      );
    });
  }
}
