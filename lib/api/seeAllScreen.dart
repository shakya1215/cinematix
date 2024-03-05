import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../newDetail.dart';
import '../widgets/constants.dart';
import 'api.dart';

class SeeAllScreen extends StatefulWidget {
  final String title;
  final String category;
  final bool kidsMode; // Boolean parameter for kidsMode with default value false

  SeeAllScreen({required this.title, required this.category, this.kidsMode = false}); // Set default value to false

  @override
  _SeeAllScreenState createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  List<Movie> _allMovies = [];
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadMoreMovies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreMovies();
    }
  }

  Future<void> _loadMoreMovies() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      List<Movie> newMovies = [];
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
      _page++;
      setState(() {
        _allMovies.addAll(newMovies);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: widget.kidsMode ? const Color.fromARGB(255, 43, 132, 173) : null, // Set background color based on kidsMode
      body: GridView.builder(
        controller: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 0.7,
        ),
        itemCount: _allMovies.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen1(movie: _allMovies[index]),
                ),
              );
            },
            child: GridTile(
              child: Image.network('${Constants.imagePath}${_allMovies[index].posterPath}'),
            ),
          );
        },
      ),
    );
  }
}
