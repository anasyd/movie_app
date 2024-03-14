import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_app/api/api_client.dart';
import 'package:movie_app/models/cast.dart';
import 'package:movie_app/models/movies.dart';

// Referenced
// https://www.youtube.com/@techieblossom
// Abstracting implementation from method
abstract class MovieApi {
  Future<List<Movie>> getTrendingMovies();
  Future<List<Movie>> getTopRatedMovies();
  Future<List<Movie>> getSearchResults(String query);
  Future<List<Cast>> getCastList(int id);
}

// Referenced
// https://www.youtube.com/@techieblossom
class MovieApiImpl extends MovieApi {
  final ApiClient _client;

  MovieApiImpl(this._client);

  static const _trendingUrlPath = 'trending/movie/day';
  static const _topRatedUrlPath = 'movie/top_rated';
  static const _firebaseTrending = 'trending_movies';
  static const _firebaseTopRated = 'top_rated';
  static const _searchUrlPath = "search/movie";
  static const _lastUpdateKeyTrending = 'last_trending_update';
  static const _lastUpdateKeyTopRated = 'last_top_rated_update';

  // DateTime? _lastUpdateTrending;
  // DateTime? _lastUpdateTopRated;

  Future<void> _saveLastUpdate(String key) async {
    final timestamp = DateTime.now();
    await FirebaseFirestore.instance
        .collection('app_settings')
        .doc(key)
        .set({'timestamp': timestamp});
    // if (key == _lastUpdateKeyTrending) {
    //   _lastUpdateTrending = timestamp;
    // } else if (key == _lastUpdateKeyTopRated) {
    //   _lastUpdateTopRated = timestamp;
    // }
  }

  Future<DateTime?> _getLastUpdate(String key) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('app_settings')
        .doc(key)
        .get();
    if (snapshot.exists) {
      final timestamp = snapshot.data()?['timestamp'] as Timestamp?;
      return timestamp?.toDate();
    }
    return null;
  }

  Future<void> _fetchAndUpdateMovies(
      String apiUrl, String firebaseCollection, String lastUpdateKey) async {
    final response = await _client.get(apiUrl);
    final data = response['results'] as List;
    final movies = data.map((movie) => Movie.fromJson(movie)).toList();

    // Fetch existing movie documents from Firestore
    final existingMovies =
        await FirebaseFirestore.instance.collection(firebaseCollection).get();

    // Create a list of existing movie IDs
    final existingMovieIds = existingMovies.docs.map((doc) => doc.id).toSet();

    // Create a list of new movie IDs
    final newMovieIds = movies.map((movie) => movie.id).toSet();

    // Remove movies not in the new list
    final moviesToRemove = existingMovieIds.difference(newMovieIds);
    for (final id in moviesToRemove) {
      await FirebaseFirestore.instance
          .collection(firebaseCollection)
          .doc(id)
          .delete();
    }

    // Add new movies
    final moviesToAdd =
        movies.where((movie) => !existingMovieIds.contains(movie.id));
    for (final movie in moviesToAdd) {
      await FirebaseFirestore.instance
          .collection(firebaseCollection)
          .add(movie.toJson());
    }
  }

  @override
  Future<List<Cast>> getCastList(int id) async {
    try {
      final response = await _client.get('movie/$id/credits');
      final data = response['cast'] as List;
      final cast = data.map((cast) => Cast.fromJson(cast)).toList();
      return cast;
    } on SocketException {
      // No network exception
      throw const SocketException("No network");
    } on Exception {
      // Any other exception
      throw Exception("Something else");
    }
  }

  @override
  Future<List<Movie>> getSearchResults(String query) async {
    try {
      final response =
          await _client.get(_searchUrlPath, params: {'query': query});
      final data = response['results'] as List;
      final movies = data.map((movie) => Movie.fromJson(movie)).toList();
      return movies;
    } on SocketException {
      // No network exception
      throw const SocketException("No network");
    } on Exception {
      // Any other exception
      throw Exception("Something else");
    }
  }

  @override
  Future<List<Movie>> getTrendingMovies() async {
    try {
      final lastUpdate = await _getLastUpdate(_lastUpdateKeyTrending);
      final now = DateTime.now();

      if (lastUpdate == null || now.difference(lastUpdate).inDays >= 1) {
        await _fetchAndUpdateMovies(
            _trendingUrlPath, _firebaseTrending, _lastUpdateKeyTrending);
        await _saveLastUpdate(_lastUpdateKeyTrending);
      }

      final response = await _client.get(_trendingUrlPath);
      final data = response['results'] as List;
      final movies = data.map((movie) => Movie.fromJson(movie)).toList();

      return movies;
    } on SocketException {
      throw const SocketException("No network");
    } catch (e) {
      // If any other exception other than network
      // Get data from firebase
      final snapshot =
          await FirebaseFirestore.instance.collection(_firebaseTrending).get();
      final movies =
          snapshot.docs.map((doc) => Movie.fromJson(doc.data())).toList();
      return movies;
    }
  }

  @override
  Future<List<Movie>> getTopRatedMovies() async {
    try {
      final lastUpdate = await _getLastUpdate(_lastUpdateKeyTopRated);
      final now = DateTime.now();

      if (lastUpdate == null || now.difference(lastUpdate).inDays >= 1) {
        await _fetchAndUpdateMovies(
            _topRatedUrlPath, _firebaseTopRated, _lastUpdateKeyTopRated);
        await _saveLastUpdate(_lastUpdateKeyTopRated);
      }

      final response = await _client.get(_topRatedUrlPath);
      final data = response['results'] as List;
      final movies = data.map((movie) => Movie.fromJson(movie)).toList();
      return movies;
    } on SocketException {
      throw const SocketException("No network");
    } catch (e) {
      // If any other exception other than network
      // Get data from firebase
      final snapshot =
          await FirebaseFirestore.instance.collection(_firebaseTopRated).get();
      final movies =
          snapshot.docs.map((doc) => Movie.fromJson(doc.data())).toList();
      return movies;
    }
  }
}
