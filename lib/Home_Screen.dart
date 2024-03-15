import 'dart:async';

import 'package:cinematic/api/seeAllScreen.dart';
import 'package:cinematic/auth.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'NavigationBar.dart';
import 'api/api.dart';
import 'login_Screen.dart';
import 'main.dart';
import 'models/movie.dart';
import 'widgets/TrendingSLider.dart';
import 'widgets/movieSilder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> trendingMovies;
  late Future<List<Movie>> topRatedMovies;
  late Future<List<Movie>> upComingMovies;

  final User? user = Auth().currentUser;
  int page = 1;
  bool kidsMode = false; // Track kids mode state
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  @override
  void initState() {
    super.initState();
    checkInternetAndLoadMovies();

    // Subscribe to connectivity changes
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
        // If internet connectivity is available, reload movies
        checkInternetAndLoadMovies();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    // Cancel the connectivity subscription to prevent memory leaks
    connectivitySubscription.cancel();
  }

  Future<void> checkInternetAndLoadMovies() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // If there is no internet connection, show an error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('No Internet Connection'),
          content: Text('Please check your internet connection and try again.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // If there is internet connection, load movies
      loadMovies();
    }
  }

  void loadMovies() {
    trendingMovies = Api().getTrendingMovies(page: page, kidsMode: kidsMode);
    topRatedMovies = Api().getTopRatedMovies(page: page, kidsMode: kidsMode);
    upComingMovies = Api().getUpComingMovies(page: page, kidsMode: kidsMode);
    // Force rebuild of widget tree to reload movies
    setState(() {});
  }

  Future<void> signOut() async {
    // Set Remember Me preference to false when the user logs out
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember_me', false);

    await Auth().signOut();
    // Navigate to LoginPage after sign out
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SplashScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kidsMode ? Color.fromARGB(255, 68, 140, 173) : null, // Set background color based on kidsMode
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(140.0),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Image.asset(
                'myAssets/SCinematix.png',
                fit: BoxFit.fill,
                height: 200, // Increase the height to 150
                width: 200,  // Increase the width to 150
              ),
              centerTitle: true,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    'Kids Mode for movies',
                    style: GoogleFonts.aBeeZee(fontSize: 16.0),
                  ),
                  SizedBox(width: 8.0),
                  Switch(
                    value: kidsMode,
                    onChanged: (newValue) {
                      setState(() {
                        kidsMode = newValue; // Update kidsMode directly with the new value
                        loadMovies(); // Reload movies based on the updated kidsMode
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      kidsMode ? 'Kids: Action Anime' : 'Trending movies',
                      style: GoogleFonts.aBeeZee(
                        fontSize: 25,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent, // Set the background color to transparent
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SeeAllScreen(
                              title: kidsMode ? 'Kids: Action Anime' : 'Trending Movies',
                              category: 'trending', // Update to match the category
                              kidsMode: kidsMode,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'See More',
                        style: TextStyle(color: Colors.white), // Set the text color to white
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  child: FutureBuilder(
                    future: trendingMovies,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      } else if (snapshot.hasData) {
                        final data = snapshot.data;
                        return TrendingSlider(snapshot: snapshot);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      kidsMode ? 'Kids: Animation' : 'Top Rated Movies',
                      style: GoogleFonts.aBeeZee(
                        fontSize: 25,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent, // Set the background color to transparent
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SeeAllScreen(
                              title: kidsMode ? 'Kids: Animation' : 'Top Rated Movies',
                              category: 'top_rated',
                              kidsMode: kidsMode, // Update to match the category
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'See More',
                        style: TextStyle(color: Colors.white), // Set the text color to white
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  child: FutureBuilder(
                    future: topRatedMovies,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      } else if (snapshot.hasData) {
                        final data = snapshot.data;
                        return movieSlider(snapshot: snapshot);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      kidsMode ? 'Kids: Romantic Anime' : 'Upcoming Movies',
                      style: GoogleFonts.aBeeZee(
                        fontSize: 25,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent, // Set the background color to transparent
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SeeAllScreen(
                              title: kidsMode ? 'Kids: Romantic Anime' : 'Upcoming Movies',
                              category: 'upcoming', 
                              kidsMode: kidsMode,// Update to match the category
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'See More',
                        style: TextStyle(color: Colors.white), // Set the text color to white
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  child: FutureBuilder(
                    future: upComingMovies,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      } else if (snapshot.hasData) {
                        final data = snapshot.data;
                        return movieSlider(snapshot: snapshot);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
        
            ListTile(
              title: Text('Logout'),
              leading: Icon(Icons.logout),
              onTap: signOut,
            ),
          ],
        ),
      ),
    );
  }
}
