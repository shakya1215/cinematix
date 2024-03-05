import 'dart:convert';
import 'package:epawelaflutter/models/movie.dart';
import 'package:http/http.dart' as http;
import 'packa';
import 'package:epawelaflutter/widgets/constants.dart';

class Api {
  static const String _apiKey = Constants.apiKey;
  static const String _baseUrl = 'https://api.themoviedb.org/3';

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
}
