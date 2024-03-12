import 'package:flutter/material.dart';
import 'package:movie_app/UI/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _selectedTheme = lightMode;

  ThemeProvider({bool isDarkMode = false}) {
    _selectedTheme = isDarkMode ? darkMode : lightMode;
  }

  // Returns current theme scheme
  ThemeData get getTheme => _selectedTheme;

  // Toggle theme and save to local preferences
  Future<void> toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_selectedTheme == lightMode) {
      _selectedTheme = darkMode;
      prefs.setBool('isDarkTheme', true);
    } else {
      _selectedTheme = lightMode;
      prefs.setBool('isDarkTheme', false);
    }
    notifyListeners();
  }
}
