import 'package:flutflix/searchBar.dart';
import 'package:flutter/material.dart';
import 'package:flutflix/Home_Screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class mainNavigator extends StatefulWidget {

  @override
  _mainNavigatorState createState() => _mainNavigatorState();
}

class _mainNavigatorState extends State<mainNavigator> {
  int _selectedIndex = 0;
  int value = 0;

  List<Widget> _screens =[
    HomeScreen(),
    SearchPage(),


  ];
  
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _screens [_selectedIndex],
        bottomNavigationBar:  Container(
          color: Colors.black,

          child:  Padding(
            padding: const EdgeInsets.symmetric(
              horizontal:5.0,
              vertical: 20,
            ),
            child:  GNav(
              backgroundColor: Colors.black45,
              tabBackgroundColor: Colors.black87 ,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              tabs: const [
                GButton(
                  gap: 10,
                  icon: Icons.home,
                  text: 'Home' ,
                  ),
                GButton(
                  gap: 10,
                  icon: Icons.search,
                  text: 'Search' ,
                  ),
                GButton(
                  gap: 10,
                  icon: Icons.bookmark,
                  text: 'wishlist' ,
                  ),
                GButton(
                  gap: 10,
                  icon: Icons.settings,
                  text: 'Settings' ,
                  ),          
              ],


            ),
          ),

        ),
      )
      
      );
  }
}