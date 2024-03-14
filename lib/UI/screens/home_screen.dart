import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:movie_app/api/api.dart';
import 'package:movie_app/api/api_client.dart';
import 'package:movie_app/constants.dart';
import 'package:movie_app/models/movies.dart';
import 'package:movie_app/UI/widgets/horizontal_carousel_slider.dart';
import 'package:movie_app/UI/widgets/horizontal_slider.dart';
import 'package:movie_app/UI/widgets/vertical_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    _loadLayoutPreference();
  }

  _loadLayoutPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Load layout preference from SharedPreferences
      isVertical = prefs.getBool("isVertical") ?? true;
    });
  }

  _saveLayoutPreference(bool isVertical) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save layout preference to SharedPreferences
    prefs.setBool("isVertical", isVertical);
  }

  static const double verticalPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('MOVIEDB', style: Theme.of(context).textTheme.headlineSmall),
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
              // Displaying section title for trending movies
              "Trending Movies",
              style: Theme.of(context).textTheme.headlineSmall,
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
                        // Displaying error message if there's an error
                        child: Text(MessageConstants.errorMessage),
                      );
                    } else if (snapshot.hasData) {
                      // Displaying horizontal carousel slider with trending movies
                      return HorizontalCarouselSlider(snapshot: snapshot);
                    } else {
                      return const Center(
                        // Displaying loading indicator while data is being fetched
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
                  // Displaying section title for top rated movies
                  "Top Rated",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  // Toggle between vertical list and horizontal list icons based on orientation
                  icon: Icon(
                    isVertical ? Icons.panorama_horizontal : Icons.list,
                  ),
                  onPressed: () {
                    setState(() {
                      // Toggle the orientation when the icon is pressed
                      isVertical = !isVertical;

                      // Save the layout preference
                      _saveLayoutPreference(isVertical);
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
                              // Displaying error message if there's an error
                              child: Text(MessageConstants.errorMessage),
                            );
                          } else if (snapshot.hasData) {
                            // Displaying vertical slider with movies
                            return VerticalSlider(snapshot: snapshot);
                          } else {
                            return const Center(
                              // Displaying loading indicator while data is being fetched
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
                              // Displaying error message if there's an error
                              child: Text(MessageConstants.errorMessage),
                            );
                          } else if (snapshot.hasData) {
                            // Displaying horizontal slider with movies
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
      )),
    );
  }
}
