import 'package:flutter/material.dart';
import 'package:movie_app/models/movies.dart';

class MovieDetailScren extends StatelessWidget {
  const MovieDetailScren({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: Text(movie.title)),
      body: Center(child: Text(movie.title)),
    );
  }
}
