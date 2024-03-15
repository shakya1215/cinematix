import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'Home_Screen.dart';
import 'TvSeriesScreen.dart';
import 'mylistscreen.dart';
import 'searchBar.dart';

class MainNavigator extends StatefulWidget {
  @override
  _MainNavigatorState createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _selectedIndex = 0; // Index of the selected tab

  List<Widget> _screens = [
    HomeScreen(), // Screen for displaying home content
    tvSeriesScreen(), // Screen for displaying TV series
    SearchPage(), // Screen for searching content
    FavoritesWatchlistScreen(), // Screen for displaying favorites and watchlist
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _screens[_selectedIndex], // Display the selected screen
        bottomNavigationBar: Container(
          color: Colors.black, // Background color of the bottom navigation bar
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5.0,
              vertical: 20,
            ),
            child: GNav(
              backgroundColor: Colors.black45, // Background color of the navigation bar
              tabBackgroundColor: Colors.black87, // Background color of the selected tab
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index; // Update the selected index when a tab is tapped
                });
              },
              tabs: const [
                GButton(
                  gap: 10,
                  icon: Icons.movie_creation_outlined,
                  text: 'Movie',
                ),
                GButton(
                  gap: 10,
                  icon: Icons.tv_rounded,
                  text: 'Tv series',
                ),
                GButton(
                  gap: 10,
                  icon: Icons.search,
                  text: 'Search',
                ),
                GButton(
                  gap: 10,
                  icon: Icons.book_rounded,
                  text: 'Wishlist',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
