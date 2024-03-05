import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/api.dart';
import 'api/seeAllScreen.dart';
import 'auth.dart';
import 'main.dart';
import 'models/movie.dart';
import 'widgets/TrendingSLider.dart';
import 'widgets/movieSilder.dart'; // Import your authentication class

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
  void initState() {
    super.initState();
    loadMovies();
  }

  void loadMovies() {
    trendingMovies = Api().getTrendingMovies(page: page, kidsMode: kidsMode);
    topRatedMovies = Api().getTopRatedMovies(page: page, kidsMode: kidsMode);
    upComingMovies = Api().getUpComingMovies(page: page, kidsMode: kidsMode);
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
                'assets/flutflix.png',
                fit: BoxFit.cover,
                height: 40,
                filterQuality: FilterQuality.high,
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
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
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
