import 'package:flutter/material.dart';
import 'package:movie_app/UI/widgets/vertical_slider.dart';
import 'package:movie_app/constants.dart';
import 'package:movie_app/models/movies.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  late Future<List<Movie>> searchResults;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: TextField(
            controller: _searchController,
            decoration: const InputDecoration(hintText: "Search for movies"),
          ),
          actions: [IconButton(onPressed: () => {}, icon: Icon(Icons.search))]),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
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
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }))
        ],
      )),
    );
  }
}
