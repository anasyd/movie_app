import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/api/api_constants.dart';
import 'package:movie_app/constants.dart';
import 'package:movie_app/models/movies.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: Text(movie.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ClipRRect(
                // Clip the movie poster to a circular shape
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    // Set the height of the movie poster
                    height: 500,
                    child: movie.posterPath != null
                        ? CachedNetworkImage(
                            // Use the CachedNetworkImage widget to display the movie poster
                            imageUrl:
                                '${ApiConstants.BASE_IMAGE_URL}${movie.posterPath}',
                            fit: BoxFit.cover,
                          )
                        : Text(MessageConstants.imageErrorMessage)),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  movie.overview,
                  style: GoogleFonts.aBeeZee(fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "Vote average ${movie.voteAverage}",
                style: GoogleFonts.aBeeZee(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
