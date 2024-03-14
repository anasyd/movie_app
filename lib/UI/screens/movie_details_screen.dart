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

  final Movie movie;

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<List<Cast>> castList;

  @override
  void initState() {
    super.initState();
    // creating instance of ApiClient class
    ApiClient apiClient = ApiClient(Client());

    // creating instance of MovieApiImpl class
    MovieApi dataSource = MovieApiImpl(apiClient);
    castList = dataSource.getCastList(widget.movie.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: Text(widget.movie.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                // Clip the movie poster to a circular shape
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
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
                            child: Text(MessageConstants.imageErrorMessage))),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.movie.overview,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Vote average ${widget.movie.voteAverage}",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Cast",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(
                // Horizontal List View
                child: FutureBuilder(
                    future: castList,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          // Displaying error message
                          child: Center(
                              child: Text(MessageConstants.errorMessage)),
                        );
                      } else if (snapshot.hasData) {
                        return HorizontalSlider(snapshot: snapshot);
                      } else {
                        return const Center(
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
