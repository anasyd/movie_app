import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:movie_app/UI/widgets/vertical_slider.dart';
import 'package:movie_app/api/api.dart';
import 'package:movie_app/api/api_client.dart';
import 'package:movie_app/constants.dart';
import 'package:movie_app/models/movies.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    // creating instance of ApiClient class
    ApiClient apiClient = ApiClient(Client());

    // creating instance of MovieApiImpl class
    dataSource = MovieApiImpl(apiClient);
  }

  final TextEditingController _searchController = TextEditingController();

  // Initialize searchResults to null
  late Future<List<Movie>>? searchResults = null;

  // Strores if user has searched anything
  bool isSearchButtonEnabled = false;

  late MovieApi dataSource;
  // Function to search
  Future<void> _performSearch() async {
    final data = dataSource.getSearchResults(_searchController.text);
    setState(() {
      searchResults = Future.value(data);
    });
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
              height: MediaQuery.of(context).size.height * 0.8,
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
