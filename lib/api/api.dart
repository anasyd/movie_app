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

  // Function to save the last update timestamp for a given key to Firestore
  Future<void> _saveLastUpdate(String key) async {
    // Get current timestamp
    final timestamp = DateTime.now();
    await FirebaseFirestore.instance
        // Access the 'app_settings' collection
        .collection('app_settings')

        // Get document with the provided key
        .doc(key)

        // Set the 'timestamp' field to the current timestamp
        .set({'timestamp': timestamp});
  }

// Function to retrieve the last update timestamp for a given key from Firestore
  Future<DateTime?> _getLastUpdate(String key) async {
    final snapshot = await FirebaseFirestore.instance
        // Access the 'app_settings' collection
        .collection('app_settings')

        // Get document with the provided key
        .doc(key)

        // Get document snapshot
        .get();
    if (snapshot.exists) {
      // Retrieve timestamp from snapshot data
      final timestamp = snapshot.data()?['timestamp'] as Timestamp?;

      // Convert Firestore Timestamp to DateTime and return
      return timestamp?.toDate();
    }

    // Return null if the document does not exist
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
      // Get cast list for a movie from the API
      final response = await _client.get('movie/$id/credits');

      // Extract cast data from the response
      final data = response['cast'] as List;

      // Map the cast data to Cast objects
      final cast = data.map((cast) => Cast.fromJson(cast)).toList();

      // Return the cast list
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
      // Search for movies with the provided query
      final response =
          await _client.get(_searchUrlPath, params: {'query': query});

      // Extract movie search results from the response
      final data = response['results'] as List;

      // Map the movie data to Movie objects
      final movies = data.map((movie) => Movie.fromJson(movie)).toList();

      // Return the list of search results
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
      // Get the last update timestamp for trending movies
      final lastUpdate = await _getLastUpdate(_lastUpdateKeyTrending);

      // Get the current timestamp
      final now = DateTime.now();

      // Check if the data needs to be updated (either it's the first update or more than a day has passed)
      if (lastUpdate == null || now.difference(lastUpdate).inDays >= 1) {
        // Fetch and update movies from the API
        await _fetchAndUpdateMovies(
            _trendingUrlPath, _firebaseTrending, _lastUpdateKeyTrending);

        // Save the last update timestamp
        await _saveLastUpdate(_lastUpdateKeyTrending);
      }

      // Get trending movies from the API
      final response = await _client.get(_trendingUrlPath);
      final data = response['results'] as List;
      final movies = data.map((movie) => Movie.fromJson(movie)).toList();

      // Return the list of trending movies
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

      // Return the list of trending movies from Firebase
      return movies;
    }
  }

  @override
  Future<List<Movie>> getTopRatedMovies() async {
    try {
      // Get the last update timestamp for topRated movies
      final lastUpdate = await _getLastUpdate(_lastUpdateKeyTopRated);

      // Get the current timestamp
      final now = DateTime.now();

      // Check if the data needs to be updated (either it's the first update or more than a day has passed)
      if (lastUpdate == null || now.difference(lastUpdate).inDays >= 1) {
        // Fetch and update movies from the API
        await _fetchAndUpdateMovies(
            _topRatedUrlPath, _firebaseTopRated, _lastUpdateKeyTopRated);

        // Save the last update timestamp
        await _saveLastUpdate(_lastUpdateKeyTopRated);
      }

      // Get topRated movies from the API
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

      // Return the list of topRated movies from Firebase
      return movies;
    }
  }
}
