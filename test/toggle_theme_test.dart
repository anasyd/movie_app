import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/UI/theme/theme.dart';
import 'package:movie_app/UI/theme/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Test case: Default theme is light
  test('Default theme is light', () {
    // Create a ThemeProvider instance
    final themeProvider = ThemeProvider();

    // Verify that the default theme is light mode
    expect(themeProvider.getTheme, equals(lightMode));
  });

  // Test case: Toggle theme
  test('Toggle theme', () async {
    // Mock SharedPreferences for testing
    SharedPreferences.setMockInitialValues({});

    // Create a ThemeProvider instance
    final themeProvider = ThemeProvider();

    // Toggle the theme
    await themeProvider.toggleTheme();

    // Verify that the theme has been toggled to dark mode
    expect(themeProvider.getTheme, equals(darkMode));

    // Toggle the theme again
    await themeProvider.toggleTheme();

    // Verify that the theme has been toggled back to light mode
    expect(themeProvider.getTheme, equals(lightMode));
  });

  // Test case: Toggle theme and persist in shared preferences
  test('Toggle theme and persist in shared preferences', () async {
    // Mock SharedPreferences for testing
    SharedPreferences.setMockInitialValues({});

    // Create a ThemeProvider instance
    final themeProvider = ThemeProvider();

    // Toggle the theme
    await themeProvider.toggleTheme();

    // Verify that the theme has been toggled to dark mode
    expect(themeProvider.getTheme, equals(darkMode));

    // Get shared preferences instance
    final prefs = await SharedPreferences.getInstance();

    // Verify that the theme mode has been persisted in shared preferences
    expect(prefs.getBool('isDarkTheme'), equals(true));

    // Toggle the theme again
    await themeProvider.toggleTheme();

    // Verify that the theme has been toggled back to light mode
    expect(themeProvider.getTheme, equals(lightMode));

    // Verify that the theme mode has been updated in shared preferences
    expect(prefs.getBool('isDarkTheme'), equals(false));
  });
}
