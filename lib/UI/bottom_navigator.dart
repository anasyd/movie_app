import 'package:flutter/material.dart';
import 'package:movie_app/UI/screens/favourites_screen.dart';
import 'package:movie_app/UI/screens/home_screen.dart';
import 'package:movie_app/UI/screens/search_screen.dart';
import 'package:movie_app/UI/screens/settings_screen.dart';

class AppBottomBar extends StatefulWidget {
  const AppBottomBar({super.key});
  @override
  State<AppBottomBar> createState() => _AppBottomBar();
}

class _AppBottomBar extends State<AppBottomBar> {
  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    SearchScreen(),
    FavouriteScreen(),
    SettingsScreen(),
  ];

  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(child: _pages.elementAt(_currentPageIndex)),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: _currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.search),
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.favorite),
            icon: Icon(Icons.favorite_outline_sharp),
            label: 'Favourites',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
