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

// Text controller for the search input field
  final TextEditingController _searchController = TextEditingController();

  // Initialize searchResults to null
  late Future<List<Movie>>? searchResults = null;

  // Strores if user has searched anything
  bool isSearchButtonEnabled = false;

  late MovieApi dataSource;

  // Function to search
  Future<void> _performSearch() async {
    // Close the keyboard
    FocusScope.of(context).unfocus();

    // Get search results
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

              // Placeholder text for the search field
              decoration: const InputDecoration(hintText: "Search for movies"),
              onChanged: (text) {
                setState(() {
                  // Enable search button if text is not empty
                  isSearchButtonEnabled = text.isNotEmpty;
                });
              }),
          actions: [
            IconButton(
                // Perform search if button is enabled
                onPressed: isSearchButtonEnabled ? _performSearch : null,

                // Icon for the search button
                icon: const Icon(Icons.search))
          ]),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
              // Setting height to 80% of the screen height
              height: MediaQuery.of(context).size.height * 0.8,

              // Vertical List view containing search results
              child: FutureBuilder(
                  future: searchResults,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        // Displaying error message if there's an error
                        child: Text(MessageConstants.errorMessage),
                      );
                    } else if (snapshot.hasData) {
                      // If there is data render it
                      return VerticalSlider(snapshot: snapshot);
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      // Displaying loading indicator while data is being fetched
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      // Displaying nothing when there are no search results
                      return const SizedBox.shrink();
                    }
                  }))
        ],
      )),
    );
  }
}
