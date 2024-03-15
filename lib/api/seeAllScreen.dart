import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../newDetail.dart';
import '../widgets/constants.dart';
import 'api.dart';

class SeeAllScreen extends StatefulWidget {
  final String title; // Title of the screen
  final String category; // Category of movies to display
  final bool kidsMode; // Boolean parameter for kidsMode with default value false

  SeeAllScreen({required this.title, required this.category, this.kidsMode = false}); // Constructor with default value for kidsMode

  @override
  _SeeAllScreenState createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen> {
  final ScrollController _scrollController = ScrollController(); // Controller for scrolling
  bool _isLoading = false; // Indicator for loading state
  List<Movie> _allMovies = []; // List to store all movies
  int _page = 1; // Current page number for pagination

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener); // Add scroll listener
    _loadMoreMovies(); // Load initial set of movies
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose the scroll controller
    super.dispose();
  }

  void _scrollListener() {
    // Listen for scroll events
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreMovies(); // Load more movies when reaching the bottom
    }
  }

  Future<void> _loadMoreMovies() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true; // Set loading state to true
      });

      List<Movie> newMovies = [];
      // Determine which API method to call based on the category
      if (widget.category == 'trending') {
        newMovies = await Api().getTrendingMovies(page: _page, kidsMode: widget.kidsMode);
      } else if (widget.category == 'top_rated') {
        newMovies = await Api().getTopRatedMovies(page: _page, kidsMode: widget.kidsMode);
      } else if (widget.category == 'upcoming') {
        newMovies = await Api().getUpComingMovies(page: _page, kidsMode: widget.kidsMode);
      } else if (widget.category == 'trending_tv') {
        newMovies = await Api().getTrendingTv(page: _page);
      } else if (widget.category == 'top_rated_tv') {
        newMovies = await Api().getTopRatedTv(page: _page);
      } else if (widget.category == 'popular_tv') {
        newMovies = await Api().getPopularTv(page: _page);
      }
      _page++; // Increment page number for pagination
      setState(() {
        _allMovies.addAll(newMovies); // Add new movies to the list
        _isLoading = false; // Set loading state to false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), // Display title in the app bar
        backgroundColor: Colors.transparent, // Set app bar background color to transparent
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Show dropdown menu for sorting
              showSortDropdown(context);
            },
          ),
        ],
      ),
      backgroundColor: widget.kidsMode ? const Color.fromARGB(255, 43, 132, 173) : null, // Set background color based on kidsMode
      body: GridView.builder(
        controller: _scrollController, // Assign scroll controller to the grid view
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 0.7,
        ),
        itemCount: _allMovies.length, // Set number of items in the grid view
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigate to movie detail screen when tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen1(movie: _allMovies[index]),
                ),
              );
            },
            child: GridTile(
              child: Image.network('${Constants.imagePath}${_allMovies[index].posterPath}'), // Display movie poster image
            ),
          );
        },
      ),
    );
  }

  void showSortDropdown(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Show dialog for sorting options
        return AlertDialog(
          title: Text('Sort By'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Alphabetical (Ascending)'),
                onTap: () {
                  // Sort movies alphabetically in ascending order
                  setState(() {
                    _allMovies.sort((a, b) => a.title.compareTo(b.title));
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Alphabetical (Descending)'),
                onTap: () {
                  // Sort movies alphabetically in descending order
                  setState(() {
                    _allMovies.sort((a, b) => b.title.compareTo(a.title));
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
