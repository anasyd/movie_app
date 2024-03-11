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

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:movie_app/theme/theme_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:movie_app/screens/settings_screen.dart';

// void main() {
//   testWidgets('Toggle theme test', (WidgetTester tester) async {
//     // Build our app and trigger a frame.
//     await tester.pumpWidget(
//       ChangeNotifierProvider(
//         create: (_) => ThemeProvider(),
//         child: MaterialApp(
//           home: SettingsScreen(),
//         ),
//       ),
//     );

//     // Find the Dark Theme ListTile
//     final darkThemeListTile = find.byKey(ValueKey('ThemeSwitch'));
//     expect(darkThemeListTile, findsOneWidget);

//     // Tap on the Dark Theme ListTile
//     await tester.tap(darkThemeListTile);
//     await tester.pump();

//     // Verify that the theme is toggled
//     expect(tester.getTheme(), equals(ThemeMode.dark));
//   });
// }
