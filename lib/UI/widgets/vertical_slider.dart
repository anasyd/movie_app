import 'package:cached_network_image/cached_network_image.dart'; // Import the CachedNetworkImage widget
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/api/api_constants.dart'; // Import the ApiConstants class
import 'package:movie_app/UI/screens/movie_details_screen.dart'; // Import the MovieDetailScreen widget

class VerticalSlider extends StatelessWidget {
  const VerticalSlider({
    super.key,
    required this.snapshot,
  });

  final AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Set the height of the movie details to 60% of the available width
      height: MediaQuery.of(context).size.height * 0.6,
      // Build a ListView.builder widget that displays a vertical list of movies
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: snapshot.data.length,
        itemBuilder: (context, index) {
          final movie = snapshot.data[index]; // Get the current movie object
          return GestureDetector(
            onTap: () {
              // Navigate to the MovieDetailScreen when the user taps on a movie
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailScreen(
                    movie: movie,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                // Use a Row widget to display the movie poster and details side-by-side
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    // Clip the movie poster to a circular shape
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      // Set the width of the movie poster
                      width: 150,

                      // Set the height of the movie poster
                      height: 200,
                      child: CachedNetworkImage(
                        // Use the CachedNetworkImage widget to display the movie poster
                        imageUrl:
                            '${ApiConstants.BASE_IMAGE_URL}${movie.posterPath}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Add some spacing between the movie poster and details
                  const SizedBox(
                    width: 8,
                  ),
                  SizedBox(
                    // Set the width of the movie details to 45% of the available width
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Column(
                      // Use a Column widget to display the movie title and overview vertically
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display the movie title
                        Text(
                          movie.title,
                          style: GoogleFonts.aBeeZee(
                              fontSize: 16, fontWeight: FontWeight.bold),

                          // Limit the number of lines to 2
                          maxLines: 2,

                          // Fade the text if it overflows
                          overflow: TextOverflow.fade,
                        ),

                        // Add some spacing between the movie title and overview
                        const SizedBox(height: 5),

                        // Display the movie overview
                        Text(
                          movie.overview,
                          style: GoogleFonts.aBeeZee(fontSize: 16),

                          // Limit the number of lines to 7
                          maxLines: 7,

                          // Fade the text if it overflows
                          overflow: TextOverflow.fade,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
