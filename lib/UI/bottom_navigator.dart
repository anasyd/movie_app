import 'package:flutter/material.dart';
import 'package:movie_app/UI/screens/home_screen.dart';
import 'package:movie_app/UI/screens/search_screen.dart';
import 'package:movie_app/UI/screens/settings_screen.dart';

// Reference
// https://api.flutter.dev/flutter/material/BottomNavigationBar-class.html
class AppBottomBar extends StatefulWidget {
  const AppBottomBar({super.key});
  @override
  State<AppBottomBar> createState() => _AppBottomBar();
}

class _AppBottomBar extends State<AppBottomBar> {
  // List of pages to be displayed in the bottom navigation bar
  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    SearchScreen(),
    SettingsScreen(),
  ];

  // Function to handle the back button press event
  Future<bool> _onBackPressed() async {
    // Show a dialog to confirm exit and await the result
    final result = await showDialog(
      context: context,

      // Builder function to create the AlertDialog widget
      builder: (context) => AlertDialog(
        // Title of the AlertDialog
        title: const Text('Confirm Exit'),

        // Content of the AlertDialog
        content: const Text('Are you sure you want to exit?'),
        actions: <Widget>[
          TextButton(
            // When clicked, close the dialog and return false
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            // When clicked, close the dialog and return true
            // Returning true exits the APP
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

// Index of the current page
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        // Setting background color
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(child: _pages.elementAt(_currentPageIndex)),
        // Creating bottom navigation bar
        bottomNavigationBar: NavigationBar(
          // Callback when a destination is selected
          onDestinationSelected: (int index) {
            setState(() {
              // Updating current page index when a destination is selected
              _currentPageIndex = index;
            });
          },
          // Setting indicator color for selected item
          indicatorColor: Colors.amber,

          // Setting selected index
          selectedIndex: _currentPageIndex,

          // Defining navigation destinations
          destinations: const <Widget>[
            // Home screen ddestination
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),

            // Search screen destination
            NavigationDestination(
              selectedIcon: Icon(Icons.search),
              icon: Icon(Icons.search),
              label: 'Search',
            ),

            // Settings screen destination
            NavigationDestination(
              selectedIcon: Icon(Icons.settings),
              icon: Icon(Icons.settings_outlined),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
