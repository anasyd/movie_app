import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:movie_app/api/api.dart';
import 'package:movie_app/api/api_client.dart';
import 'package:movie_app/constants.dart';
import 'package:movie_app/models/movies.dart';
import 'package:movie_app/UI/widgets/horizontal_carousel_slider.dart';
import 'package:movie_app/UI/widgets/horizontal_slider.dart';
import 'package:movie_app/UI/widgets/vertical_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> trendingMovies;
  late Future<List<Movie>> topRatedMovies;
  bool isVertical = true;

  @override
  void initState() {
    super.initState();
    // creating instance of ApiClient class
    ApiClient apiClient = ApiClient(Client());

    // creating instance of MovieApiImpl class
    MovieApi dataSource = MovieApiImpl(apiClient);
    trendingMovies = dataSource.getTrendingMovies();
    topRatedMovies = dataSource.getTopRatedMovies();
  }

// declaring subHeadingFontSize as a double and initializing it to 25
  final double subHeadingFontSize = 25;
  static const double verticalPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MOVIEDB',
          style: GoogleFonts.aBeeZee(
            fontSize: subHeadingFontSize,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
        // setting padding of all sides to 8
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Trending Movies",
              style: GoogleFonts.aBeeZee(fontSize: subHeadingFontSize),
            ),
            const SizedBox(
              height: verticalPadding,
            ),
            SizedBox(
              child: FutureBuilder(
                  future: trendingMovies,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        // Displaying error message
                        child: Text(MessageConstants.errorMessage),
                      );
                    } else if (snapshot.hasData) {
                      return HorizontalCarouselSlider(snapshot: snapshot);
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
            const SizedBox(
              height: verticalPadding,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Top Rated",
                  style: GoogleFonts.aBeeZee(fontSize: subHeadingFontSize),
                ),
                IconButton(
                  icon: Icon(
                    isVertical ? Icons.list : Icons.grid_view,
                  ),
                  onPressed: () {
                    setState(() {
                      isVertical = !isVertical;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: verticalPadding),

            // Checking if the user selected horizontal or vertical list view
            isVertical
                ? SizedBox(
                    // Vertical List view
                    child: FutureBuilder(
                        future: topRatedMovies,
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
                : SizedBox(
                    // Horizontal List View
                    child: FutureBuilder(
                        future: topRatedMovies,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                              // Displaying error message
                              child: Text(MessageConstants.errorMessage),
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
      )),
    );
  }
}
