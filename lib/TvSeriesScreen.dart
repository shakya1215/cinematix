import 'package:epawelaflutter/api/seeAllScreen.dart';
import 'package:epawelaflutter/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:epawelaflutter/api/api.dart';
import 'package:epawelaflutter/models/movie.dart';
import 'package:epawelaflutter/widgets/TrendingSLider.dart';
import 'package:epawelaflutter/widgets/movieSilder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth.dart'; // Import your authentication class

class tvSeriesScreen extends StatefulWidget {
  const tvSeriesScreen({Key? key}) : super(key: key);

  @override
  _tvSeriesScreenState createState() => _tvSeriesScreenState();
}

class _tvSeriesScreenState extends State<tvSeriesScreen> {
  late Future<List<Movie>> trendingTvSeries;
  late Future<List<Movie>> topRatedTvSeries;
  late Future<List<Movie>> popularTvSeries;

  final User? user = Auth().currentUser;
  int page = 1;
  
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
    trendingTvSeries = Api().getTrendingTv(page: page);
    topRatedTvSeries = Api().getTopRatedTv(page: page);
    popularTvSeries = Api().getPopularTv(page: page);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                      'Trending Tv Series',
                      style: GoogleFonts.aBeeZee(
                        fontSize: 25,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent, // Set the background color to transparent
                      ),
                      onPressed: () async {
                        List<Movie> trendingTvSeriesList = await trendingTvSeries;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SeeAllScreen(
                              title: 'Trending Tv Series',
                              category: 'trending_tv', // Pass the list of trending movies
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
                    future: trendingTvSeries,
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
                      'Top Rated Tv Series',
                      style: GoogleFonts.aBeeZee(
                        fontSize: 25,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent, // Set the background color to transparent
                      ),
                      onPressed: () async {
                        List<Movie> topRatedTvSeriesList = await topRatedTvSeries;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SeeAllScreen(
                              title: 'Top Rated Tv Series',
                              category: 'top_rated_tv', // Pass the list of trending movies
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
                    future: topRatedTvSeries,
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
                      'Popular Tv Series',
                      style: GoogleFonts.aBeeZee(
                        fontSize: 25,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent, // Set the background color to transparent
                      ),
                      onPressed: () async {
                        List<Movie> PopularTvSeriesList = await popularTvSeries;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SeeAllScreen(
                              title: 'Popular Tv Series',
                              category: 'popular_tv', // Pass the list of trending movies
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
                    future: popularTvSeries,
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
