class TvSeries {
  String title; // Title of the TV series
  String backdropPath; // Backdrop image path for the TV series
  String overView; // Overview or summary of the TV series
  String posterPath; // Poster image path for the TV series
  double voteAverage; // Average vote rating of the TV series

  TvSeries({
    required this.title,
    required this.backdropPath,
    required this.overView,
    required this.posterPath,
    required this.voteAverage,
  });

  factory TvSeries.fromJson(Map<String, dynamic> json) {
    // Factory method to create TvSeries object from JSON data
    return TvSeries(
      title: json["original_name"] ?? '', // Original name of the TV series
      backdropPath: json["backdrop_path"] ?? '', // Backdrop image path
      overView: json["overview"] ?? '', // Overview of the TV series
      posterPath: json["poster_path"] ?? '', // Poster image path
      voteAverage: (json["vote_average"] ?? 0.0).toDouble(), // Average vote rating
    );
  }
}
