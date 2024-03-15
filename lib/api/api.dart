import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/movie.dart';
import '../models/trailerModel.dart';
import '../widgets/constants.dart';

class Api {
  // Define constants for the API key and base URL.
  static const String _apiKey = Constants.apiKey;
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  // Fetch trending movies based on parameters like page number and kids mode.
  Future<List<Movie>> getTrendingMovies({int page = 1, bool kidsMode = false}) async {
    String url = '$_baseUrl/trending/movie/day?api_key=$_apiKey&page=$page';
    if (kidsMode) {
      url = '$_baseUrl/discover/movie?api_key=$_apiKey&page=$page&with_genres=16,28';
    }
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load trending movies');
    }
  }

  // Fetch top rated movies based on parameters like page number and kids mode.
  Future<List<Movie>> getTopRatedMovies({int page = 1, bool kidsMode = false}) async {
    String url = '$_baseUrl/movie/top_rated?api_key=$_apiKey&page=$page';
    if (kidsMode) {
      url = url = '$_baseUrl/discover/movie?api_key=$_apiKey&page=$page&with_genres=16';
    }
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load top rated movies');
    }
  }

  // Fetch upcoming movies based on parameters like page number and kids mode.
  Future<List<Movie>> getUpComingMovies({int page = 1, bool kidsMode = false}) async {
    String url = '$_baseUrl/movie/upcoming?api_key=$_apiKey&page=$page';
    if (kidsMode) {
      url = url = '$_baseUrl/discover/movie?api_key=$_apiKey&page=$page&with_genres=16,10749';
    }
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }

  // Fetch trending TV shows based on parameters like page number.
  Future<List<Movie>> getTrendingTv({int page = 1}) async {
    final String url = '$_baseUrl/trending/tv/day?api_key=$_apiKey&page=$page';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load trending TV shows');
    }
  }

  // Fetch top rated TV shows based on parameters like page number.
  Future<List<Movie>> getTopRatedTv({int page = 1}) async {
    final String url = '$_baseUrl/tv/top_rated?api_key=$_apiKey&page=$page';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load top rated TV shows');
    }
  }

  // Fetch popular TV shows based on parameters like page number.
  Future<List<Movie>> getPopularTv({int page = 1}) async {
    final String url = '$_baseUrl/tv/popular?api_key=$_apiKey&page=$page';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load popular TV shows');
    }
  }

  // Fetch trailers for a specific movie ID.
  Stream<List<TrailerModel>> getTrailerStream(int movieId) async* {
    final url = Uri.parse('$_baseUrl/movie/$movieId/videos?api_key=$_apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      final trailers = decodedData.map((trailerResult) => TrailerModel.fromJson(trailerResult)).toList();
      yield trailers;
    } else {
      throw Exception("Failed to fetch trailers");
    }
  }
}
