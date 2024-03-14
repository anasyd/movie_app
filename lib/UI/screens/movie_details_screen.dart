import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:movie_app/UI/widgets/cast_slider.dart';
import 'package:movie_app/api/api.dart';
import 'package:movie_app/api/api_client.dart';
import 'package:movie_app/api/api_constants.dart';
import 'package:movie_app/constants.dart';
import 'package:movie_app/models/cast.dart';
import 'package:movie_app/models/movies.dart';

class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({super.key, required this.movie});

// Movie object passed to the widget
  final Movie movie;

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  // Future object for holding the cast list
  late Future<List<Cast>> castList;

  // Vertical padding constant
  static const double verticalPadding = 16.0;

  @override
  void initState() {
    super.initState();
    // Creating instance of ApiClient class for making API requests
    ApiClient apiClient = ApiClient(Client());

    // Creating instance of MovieApiImpl class for accessing movie-related APIs
    MovieApi dataSource = MovieApiImpl(apiClient);

    // Getting the cast list for the current movie
    castList = dataSource.getCastList(widget.movie.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Setting background color
      backgroundColor: Theme.of(context).colorScheme.background,

      // App bar with the movie title
      appBar: AppBar(title: Text(widget.movie.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                // Clip the movie poster to a circular shape/ rounded edges
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(

                    // Set the width to the full width of the screen
                    width: MediaQuery.of(context).size.width,

                    // Set the height of the movie poster
                    height: 500,
                    child: widget.movie.posterPath != null
                        ? CachedNetworkImage(
                            // Use the CachedNetworkImage widget to display the movie poster
                            imageUrl:
                                '${ApiConstants.BASE_IMAGE_URL}${widget.movie.posterPath}',
                            fit: BoxFit.cover,
                          )
                        : const Center(
                            // Display no image message if poster is not available
                            child: Text(MessageConstants.noImageErrorMessage))),
              ),
              const SizedBox(
                height: verticalPadding,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  // Displaying movie overview
                  widget.movie.overview,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(
                height: verticalPadding,
              ),
              Text(
                // Displaying vote average
                "Vote average ${widget.movie.voteAverage}",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                height: verticalPadding,
              ),
              Text(
                // Displaying cast section title
                "Cast",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(
                height: verticalPadding,
              ),
              SizedBox(
                // Horizontal list view for displaying cast members
                child: FutureBuilder(
                    // Using the castList future for building the list
                    future: castList,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          // Displaying error message if there's an error
                          child: Center(
                              child: Text(MessageConstants.errorMessage)),
                        );
                      } else if (snapshot.hasData) {
                        // Displaying horizontal slider with cast members
                        return HorizontalSlider(snapshot: snapshot);
                      } else {
                        return const Center(
                          // Displaying loading indicator while data is being fetched
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
