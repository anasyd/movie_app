import 'dart:io';

import 'package:movie_app/api/api_client.dart';
import 'package:movie_app/models/movies.dart';

// Abstracting implementation from method
abstract class MovieApi {
  Future<List<Movie>> getTrendingMovies();
  Future<List<Movie>> getTopRatedMovies();
  Future<List<Movie>> getUpcomingMovies();
}

class MovieApiImpl extends MovieApi {
  final ApiClient _client;

  MovieApiImpl(this._client);

  static const _trendingUrlPath = 'trending/movie/day';
  static const _topRatedUrlPath = 'movie/top_rated';
  static const _upcomingUrlPath = "movie/upcoming";

  @override
  Future<List<Movie>> getTrendingMovies() async {
    try {
      final response = await _client.get(_trendingUrlPath);
      final data = response['results'] as List;
      final movies = data.map((movie) => Movie.fromJson(movie)).toList();
      return movies;
    } on SocketException {
      // No network exception
      throw const SocketException("No network");
    } on Exception {
      // Any other exception
      throw Exception("Something went wrong");
    }
  }

  @override
  Future<List<Movie>> getTopRatedMovies() async {
    try {
      final response = await _client.get(_topRatedUrlPath);
      final data = response['results'] as List;
      final movies = data.map((movie) => Movie.fromJson(movie)).toList();
      return movies;
    } on SocketException {
      // No network exception
      throw const SocketException("No network");
    } on Exception {
      // Any other exception
      throw Exception("Something went wrong");
    }
  }

  @override
  Future<List<Movie>> getUpcomingMovies() async {
    try {
      final response = await _client.get(_upcomingUrlPath);
      final data = response['results'] as List;
      final movies = data.map((movie) => Movie.fromJson(movie)).toList();
      return movies;
    } on SocketException {
      // No network exception
      throw const SocketException("No network");
    } on Exception {
      // Any other exception
      throw Exception("Something went wrong");
    }
  }
}
