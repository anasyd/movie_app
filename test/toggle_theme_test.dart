import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/UI/theme/theme.dart';
import 'package:movie_app/UI/theme/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group('ThemeProvider Tests', () {
    late ThemeProvider themeProvider;

    setUp(() {
      themeProvider = ThemeProvider();
    });

    test('Default theme is light', () {
      expect(themeProvider.getTheme, equals(lightMode));
    });

    test('Toggle theme', () async {
      await themeProvider.toggleTheme();
      expect(themeProvider.getTheme, equals(darkMode));
      await themeProvider.toggleTheme();
      expect(themeProvider.getTheme, equals(lightMode));
    });

    test('Theme mode is persisted in shared preferences', () async {
      SharedPreferences.setMockInitialValues({'isDarkTheme': false});
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('isDarkTheme'), equals(false));

      themeProvider = ThemeProvider();
      expect(themeProvider.getTheme, equals(lightMode));

      await themeProvider.toggleTheme();
      expect(themeProvider.getTheme, equals(darkMode));
      expect(prefs.getBool('isDarkTheme'), equals(true));

      await themeProvider.toggleTheme();
      expect(themeProvider.getTheme, equals(lightMode));
      expect(prefs.getBool('isDarkTheme'), equals(false));
    });
  });
}
