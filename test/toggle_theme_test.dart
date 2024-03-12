import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/UI/theme/theme.dart';
import 'package:movie_app/UI/theme/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  test('Default theme is light', () {
    final themeProvider = ThemeProvider();
    expect(themeProvider.getTheme, equals(lightMode));
  });

  test('Toggle theme', () async {
    SharedPreferences.setMockInitialValues({});
    final themeProvider = ThemeProvider();

    await themeProvider.toggleTheme();
    expect(themeProvider.getTheme, equals(darkMode));

    await themeProvider.toggleTheme();
    expect(themeProvider.getTheme, equals(lightMode));
  });

  test('Toggle theme and persist in shared preferences', () async {
    SharedPreferences.setMockInitialValues({});
    final themeProvider = ThemeProvider();

    await themeProvider.toggleTheme();
    expect(themeProvider.getTheme, equals(darkMode));

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('isDarkTheme'), equals(true));

    await themeProvider.toggleTheme();
    expect(themeProvider.getTheme, equals(lightMode));
    expect(prefs.getBool('isDarkTheme'), equals(false));
  });
}
