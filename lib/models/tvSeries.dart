class TvSeries{

   String title;
   String backdropPath;
   String overView;
   String posterPath;
   //String releaseDate;
   double voteAverage;

  TvSeries({

    required this.title,
    required this.backdropPath,
    required this.overView,
    required this.posterPath,
    //required this.releaseDate,
    required this.voteAverage,

  });
   
  factory TvSeries.fromJson(Map<String, dynamic> json) {
    return TvSeries(
      title: json["original_name"] ??  '',
      backdropPath: json["backdrop_path"] ?? '',
      overView: json["overview"] ?? '',
      posterPath: json["poster_path"] ?? '',
      //releaseDate: z ?? '',
      voteAverage: (json["vote_average"] ?? 0.0).toDouble(),
    );
  }



}
