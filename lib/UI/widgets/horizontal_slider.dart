import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/api/api_constants.dart';
import 'package:movie_app/UI/screens/movie_details_screen.dart';
import 'package:movie_app/constants.dart';

class HorizontalSlider extends StatelessWidget {
  const HorizontalSlider({
    super.key,
    required this.snapshot,
  });
  final AsyncSnapshot snapshot;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  // Navigate to MovieDetailScreen
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(
                                movie: snapshot.data[index],
                              )));
                },
                child: Column(
                  children: [
                    ClipRRect(
                      // Setting border radius of image
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        height: 200,
                        width: 150,
                        child: snapshot.data[index].posterPath != null
                            ? CachedNetworkImage(
                                // Use the CachedNetworkImage widget to display the movie poster
                                imageUrl:
                                    '${ApiConstants.BASE_IMAGE_URL}${snapshot.data[index].posterPath}',
                                fit: BoxFit.cover,
                              )
                            : const Center(
                                child:
                                    Text(MessageConstants.imageErrorMessage)),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: 150,
                      child: Text(
                        snapshot.data[index].title,
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
