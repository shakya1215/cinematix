import 'dart:convert';

import 'package:http/http.dart' as http;

class Api{
  static const _trendingUrl = 'https://api.themoviedb.org/3/trending/movie/day?api_key=${Constants.apiKey}';
  static const _topRatedUrl = 'https://api.themoviedb.org/3/movie/top_rated?api_key=${Constants.apiKey}';
  static const _upComingUrl = 'https://api.themoviedb.org/3/movie/upcoming?api_key=${Constants.apiKey}';
  static const _allMoviesUrl = 'https://api.themoviedb.org/3/movie/changes?api_key=${Constants.apiKey}';


  Future <List<Mogit vie>>getTrendingMovies() async{
    final response = await http.get(Uri.parse(_trendingUrl));
    if(response.statusCode == 200){
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();    
    }
    else{
      throw Exception('error ');
    }

  } 
  Future <List<Movie>>getTopRatedMovies() async{
    final response = await http.get(Uri.parse(_topRatedUrl));
    if(response.statusCode == 200){
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();    
    }
    else{
      throw Exception('error ');
    }

  } 
    Future <List<Movie>>getUpComingMovies() async{
    final response = await http.get(Uri.parse(_upComingUrl));
    if(response.statusCode == 200){
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();    
    }
    else{
      throw Exception('error ');
    }

  } 
  Future <List<Movie>>getAllMovies() async{
    final response = await http.get(Uri.parse(_allMoviesUrl));
    if(response.statusCode == 200){
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();    
    }
    else{
      throw Exception('error ');
    }




  }
  Future<int> getMoviesLength() async {
  try {
    final response = await http.get(Uri.parse(_allMoviesUrl));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      final List<Movie> movies = decodedData.map((movie) => Movie.fromJson(movie)).toList();
      return movies.length;
    } else {
      throw Exception('Failed to load movies');
    }
  } catch (error) {
    throw Exception('Error occurred: $error');
  }
}

}