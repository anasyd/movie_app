import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: TextField(
            controller: _searchController,
            decoration: InputDecoration(hintText: "Search for movies"),
          ),
          actions: [IconButton(onPressed: () => {}, icon: Icon(Icons.search))]),
      body: Center(child: Text("Search")),
    );
  }
}
