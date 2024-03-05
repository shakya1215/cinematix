class Movie {
  String title;
  String backdropPath;
  String originalTitle;
  String overView;
  String posterPath;
  String releaseDate;
  double voteAverage;
  double popularity;
  String mediaType; // Added attribute

  Movie({
    required this.title,
    required this.backdropPath,
    required this.originalTitle,
    required this.overView,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.popularity,
    required this.mediaType, // Updated constructor
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json["title"] ?? json["original_name"] ?? '',
      backdropPath: json["backdrop_path"] ?? '',
      originalTitle: json["original_title"] ?? '',
      overView: json["overview"] ?? '',
      posterPath: json["poster_path"] ?? '',
      releaseDate: json["release_date"] ?? json["first_air_date"] ?? '',
      voteAverage: (json["vote_average"] ?? 0.0).toDouble(),
      popularity: (json["popularity"] ?? 0.0).toDouble(),
      mediaType: json["media_type"] ?? 'movie', // Added mediaType with default value 'movie'
    );
  }
}
