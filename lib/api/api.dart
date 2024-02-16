import 'dart:convert';

import 'package:http/http.dart';
import 'package:movie_app/constants.dart';
import 'package:movie_app/models/movies.dart';

class Api {
  static const _baseUrl = 'https://api.themoviedb.org/3/';
  static const _trendingUrlPath =
      'trending/movie/day?api_key=${Constants.apiKey}';
  static const _topRatedUrlPath = 'movie/top_rated?api_key=${Constants.apiKey}';
  static const _upcomingUrlPath = "movie/upcoming?api_key=${Constants.apiKey}";
  Future<List<Movie>> getTrendingMovies() async {
    final response = await get(Uri.parse(_baseUrl + _trendingUrlPath));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['results'] as List;
      return data.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception("Error ${response.statusCode}");
    }
  }

  Future<List<Movie>> getTopRatedMovies() async {
    final response = await get(Uri.parse(_baseUrl + _topRatedUrlPath));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['results'] as List;
      return data.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception("Error ${response.statusCode}");
    }
  }

  Future<List<Movie>> getUpcomingMovies() async {
    final response = await get(Uri.parse(_baseUrl + _upcomingUrlPath));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['results'] as List;
      return data.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception("Error ${response.statusCode}");
    }
  }
}
