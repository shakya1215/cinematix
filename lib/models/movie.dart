class Movie {
  int id; // Movie ID
  String title; // Movie title
  String backdropPath; // Path to movie backdrop image
  String originalTitle; // Original title of the movie
  String overView; // Overview or summary of the movie
  String posterPath; // Path to movie poster image
  String releaseDate; // Release date of the movie
  double voteAverage; // Average rating of the movie
  double popularity; // Popularity rating of the movie
  String mediaType; // Type of media (movie or TV show)

  Movie({
    required this.id,
    required this.title,
    required this.backdropPath,
    required this.originalTitle,
    required this.overView,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.popularity,
    required this.mediaType, // Added attribute
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    // Factory method to create Movie object from JSON data
    return Movie(
      id: json["id"] ?? 0, // Movie ID
      title: json["title"] ?? json["original_name"] ?? '', // Movie title (fallback to original_name for TV shows)
      backdropPath: json["backdrop_path"] ?? '', // Path to movie backdrop image
      originalTitle: json["original_title"] ?? '', // Original title of the movie
      overView: json["overview"] ?? '', // Overview or summary of the movie
      posterPath: json["poster_path"] ?? '', // Path to movie poster image
      releaseDate: json["release_date"] ?? json["first_air_date"] ?? '', // Release date (fallback to first_air_date for TV shows)
      voteAverage: (json["vote_average"] ?? 0.0).toDouble(), // Average rating of the movie
      popularity: (json["popularity"] ?? 0.0).toDouble(), // Popularity rating of the movie
      mediaType: json["media_type"] ?? 'movie', // Type of media with default value 'movie'
    );
  }
}
