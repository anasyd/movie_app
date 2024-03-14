import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/firebase_options.dart';
import 'package:movie_app/UI/bottom_navigator.dart';
import 'package:movie_app/UI/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // Ensure that Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize shared preferences for storing app settings
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Initialize Firebase with default options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
    providers: [
      // Provide a ChangeNotifierProvider for managing the theme
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(
          // Use ?? operator to handle null values (e.g. when the app is launched for the first time)
          isDarkMode: prefs.getBool("isDarkTheme") ?? false,
        ),
      ),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return MaterialApp(
        // App title
        title: 'MovieDB',

        // Disable debug banner
        debugShowCheckedModeBanner: false,

        // Set the theme based on the provider
        theme: themeProvider.getTheme,

        // Set the home screen to the bottom navigation bar
        home: const AppBottomBar(),
      );
    });
  }
}
