import 'package:flutter/material.dart';
import 'package:movie_app/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _selectedTheme = lightMode;

  ThemeProvider({bool isDarkMode = true}) {
    _selectedTheme = isDarkMode ? darkMode : lightMode;
  }

  ThemeData get getTheme => _selectedTheme;

  // ThemeData _themeData = lightMode;
  // ThemeData get themData => _themeData;

  // ThemeMode _themeMode = ThemeMode.light;
  // ThemeMode get themeMode => _themeMode;

  // set themeData(ThemeData themeData) {
  //   _themeData = themeData;
  //   notifyListeners();
  // }

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
