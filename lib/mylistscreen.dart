import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import 'models/movie.dart';
import 'newDetail.dart';
import 'widgets/constants.dart';

class FavoritesWatchlistScreen extends StatefulWidget {
  @override
  _FavoritesWatchlistScreenState createState() =>
      _FavoritesWatchlistScreenState();
}

class _FavoritesWatchlistScreenState extends State<FavoritesWatchlistScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  bool isFavoritesSelected = false;
  bool isWatchlistSelected = false;
  List<Movie> favorites = [];
  List<Movie> watchlist = [];
  User? _user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchFavorites();
    fetchWatchlist();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> fetchFavorites() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .collection('favorites')
          .get();
      setState(() {
        favorites = querySnapshot.docs
            .map((doc) => Movie.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      print('Error fetching favorites: $e');
    }
  }

  Future<void> fetchWatchlist() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .collection('watchlist')
          .get();
      setState(() {
        watchlist = querySnapshot.docs
            .map((doc) => Movie.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      print('Error fetching watchlist: $e');
    }
  }

  void removeFromFavorites(Movie movie) {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .collection('favorites')
          .doc(movie.title)
          .delete();
      setState(() {
        favorites.removeWhere((element) => element.title == movie.title);
      });
      print('Movie removed from favorites');
    } catch (e) {
      print('Error removing movie from favorites: $e');
    }
  }

  void removeFromWatchlist(Movie movie) {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .collection('watchlist')
          .doc(movie.title)
          .delete();
      setState(() {
        watchlist.removeWhere((element) => element.title == movie.title);
      });
      print('Movie removed from watchlist');
    } catch (e) {
      print('Error removing movie from watchlist: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My List',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: isWatchlistSelected ? Colors.blue : Colors.red,
          labelColor: isWatchlistSelected ? Colors.blue : Colors.red,
          unselectedLabelColor: Colors.black,
          tabs: [
            Tab(
              text: 'Favorites',
              icon: Icon(
                Icons.favorite,
                color: isFavoritesSelected ? Colors.red : Colors.black,
              ),
            ),
            Tab(
              text: 'Watchlist',
              icon: Icon(
                Icons.bookmark,
                color: isWatchlistSelected ? Colors.blue : Colors.black,
              ),
            ),
          ],
          onTap: (index) {
            setState(() {
              if (index == 0) {
                isFavoritesSelected = true;
                isWatchlistSelected = false;
              } else {
                isFavoritesSelected = false;
                isWatchlistSelected = true;
              }
            });
          },
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMovieGrid(favorites, removeFromFavorites),
          _buildMovieGrid(watchlist, removeFromWatchlist),
        ],
      ),
    );
  }

  Widget _buildMovieGrid(List<Movie> movies, Function(Movie) removeFunction) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen1(movie: movies[index]),
                ),
              ).then((_) {
                fetchFavorites(); // Refresh favorites list after returning from DetailScreen1
                fetchWatchlist(); // Refresh watchlist after returning from DetailScreen1
              });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                '${Constants.imagePath}${movies[index].posterPath}',
                filterQuality: FilterQuality.high,
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}
