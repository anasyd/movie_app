import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:movie_app/UI/widgets/vertical_slider.dart';
import 'package:movie_app/api/api_constants.dart';
import 'package:movie_app/constants.dart';
import 'package:movie_app/models/movies.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();

  // Initialize searchResults to null
  late Future<List<Movie>>? searchResults = null;

  // Strores if user has searched anything
  bool isSearchButtonEnabled = false;

  // Function to search
  // void _performSearch() {}

  Future<void> _performSearch() async {
    final apiKey = ApiConstants.API_Key;
    final baseUrl = 'https://api.themoviedb.org/3';
    final searchUrl = '$baseUrl/search/movie';

    final query = _searchController.text;
    final response =
        await http.get(Uri.parse('$searchUrl?api_key=$apiKey&query=$query'));

    if (response.statusCode == 200) {
      final rawData = json.decode(response.body);
      final data = rawData['results'] as List;
      final movies = data.map((movie) => Movie.fromJson(movie)).toList();

      setState(() {
        searchResults = Future.value(movies);
      });
    } else {
      throw Exception('Failed to search for movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: TextField(
              controller: _searchController,
              decoration: const InputDecoration(hintText: "Search for movies"),
              onChanged: (text) {
                setState(() {
                  isSearchButtonEnabled = text.isNotEmpty;
                });
              }),
          actions: [
            IconButton(
                // Enables button if there is anythin in the textbox
                onPressed: isSearchButtonEnabled ? _performSearch : null,
                icon: const Icon(Icons.search))
          ]),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height,
              // Vertical List view
              child: FutureBuilder(
                  future: searchResults,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        // Displaying error message
                        child: Text(MessageConstants.errorMessage),
                      );
                    } else if (snapshot.hasData) {
                      return VerticalSlider(snapshot: snapshot);
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return const SizedBox
                          .shrink(); // Displaying nothing when there are no search results
                    }
                  }))
        ],
      )),
    );
  }
}
