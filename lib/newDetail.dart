import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'widgets/backButton.dart';
import 'widgets/constants.dart';
import 'models/movie.dart';
import 'preLoadContent.dart';

class DetailScreen1 extends StatefulWidget {
  const DetailScreen1({Key? key, required this.movie}) : super(key: key);

  final Movie movie;

  @override
  _DetailScreen1State createState() => _DetailScreen1State();
}

class _DetailScreen1State extends State<DetailScreen1> {
  final User? _user = FirebaseAuth.instance.currentUser;

  bool isFavorite = false;
  bool isWatchlisted = false;

  @override
  void initState() {
    super.initState();
    checkFavorites();
    checkWatchlist();
  }

  // Check if the current movie is in the user's favorites
  Future<void> checkFavorites() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .collection('favorites')
          .doc(widget.movie.title)
          .get();
      setState(() {
        isFavorite = snapshot.exists;
      });
    } catch (e) {
      print('Error checking favorites: $e');
    }
  }

  // Check if the current movie is in the user's watchlist
  Future<void> checkWatchlist() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .collection('watchlist')
          .doc(widget.movie.title)
          .get();
      setState(() {
        isWatchlisted = snapshot.exists;
      });
    } catch (e) {
      print('Error checking watchlist: $e');
    }
  }

  // Toggle the favorite status of the movie
  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      if (isFavorite) {
        addToFavorites(widget.movie);
      } else {
        removeFromFavorites(widget.movie);
      }
    });
  }

  // Toggle the watchlist status of the movie
  void toggleWatchlist() {
    setState(() {
      isWatchlisted = !isWatchlisted;
      if (isWatchlisted) {
        addToWatchlist(widget.movie);
      } else {
        removeFromWatchlist(widget.movie);
      }
    });
  }

  // Add the movie to the user's favorites
  void addToFavorites(Movie movie) {
    try {
      CollectionReference favoritesCollection =
          FirebaseFirestore.instance.collection('users').doc(_user!.uid).collection('favorites');
      favoritesCollection.doc(movie.title).set({
        'title': movie.title ?? '',
        'backdrop_path': movie.backdropPath ?? '',
        'original_title': movie.originalTitle ?? '',
        'overview': movie.overView ?? '',
        'poster_path': movie.posterPath ?? '',
        'release_date': movie.releaseDate ?? '',
        'vote_average': movie.voteAverage ?? 0.0,
      });
      print('Movie added to favorites');
    } catch (e) {
      print('Error adding movie to favorites: $e');
    }
  }

  // Add the movie to the user's watchlist
  void addToWatchlist(Movie movie) {
    try {
      CollectionReference watchlistCollection =
          FirebaseFirestore.instance.collection('users').doc(_user!.uid).collection('watchlist');
      watchlistCollection.doc(movie.title).set({
        'title': movie.title ?? '',
        'backdrop_path': movie.backdropPath ?? '',
        'original_title': movie.originalTitle ?? '',
        'overview': movie.overView ?? '',
        'poster_path': movie.posterPath ?? '',
        'release_date': movie.releaseDate ?? '',
        'vote_average': movie.voteAverage ?? 0.0,
      });
      print('Movie added to watchlist');
    } catch (e) {
      print('Error adding movie to watchlist: $e');
    }
  }

  // Remove the movie from the user's favorites
  void removeFromFavorites(Movie movie) {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .collection('favorites')
          .doc(movie.title)
          .delete();
      print('Movie removed from favorites');
    } catch (e) {
      print('Error removing movie from favorites: $e');
    }
  }

  // Remove the movie from the user's watchlist
  void removeFromWatchlist(Movie movie) {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .collection('watchlist')
          .doc(movie.title)
          .delete();
      print('Movie removed from watchlist');
    } catch (e) {
      print('Error removing movie from watchlist: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: backButton(), // Custom back button widget
      ),
      body: Stack(
        children: [
          // Background image of the movie poster
          Image.network(
            '${Constants.imagePath}${widget.movie.posterPath}',
            filterQuality: FilterQuality.high,
            height: 300,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 60),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Display the movie poster
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              '${Constants.imagePath}${widget.movie.posterPath}',
                              filterQuality: FilterQuality.high,
                              height: 250,
                              width: 180,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  // Buttons to add/remove from watchlist and favorites
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xFF292B37),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF292B37).withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: toggleWatchlist,
                          icon: Icon(
                            Icons.bookmark,
                            color: isWatchlisted ? Colors.blue : Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xFF292B37),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF292B37).withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: toggleFavorite,
                          icon: Icon(
                            Icons.favorite,
                            color: isFavorite ? Colors.red : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Display movie details
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Movie title
                        Text(
                          widget.movie.title,
                          style: GoogleFonts.belleza(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 15),
                        // Movie overview
                        Text(
                          widget.movie.overView,
                          style: GoogleFonts.belleza(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 15),
                        // Release date and rating
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Released date: ',
                                    style: GoogleFonts.cabin(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    widget.movie.releaseDate,
                                    style: GoogleFonts.cabin(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Rating',
                                    style: GoogleFonts.cabin(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                  ),
                                  Text(
                                    '${widget.movie.voteAverage.toStringAsFixed(1)}/10',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  // Widget to preload additional content related to the movie
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    child: PreloadContent(widget.movie.id),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
