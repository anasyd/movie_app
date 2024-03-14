import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:movie_app/api/api_constants.dart';
import 'package:movie_app/UI/screens/movie_details_screen.dart';
import 'package:movie_app/constants.dart';

class HorizontalCarouselSlider extends StatelessWidget {
  const HorizontalCarouselSlider({
    super.key,
    required this.snapshot,
  });

  final AsyncSnapshot snapshot;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CarouselSlider.builder(
        itemCount: snapshot.data.length,
        options: CarouselOptions(
          height: 300,
          autoPlay: true,
          viewportFraction: 0.60,
          enlargeCenterPage: true,
          pageSnapping: true,
          autoPlayCurve: Curves.fastOutSlowIn,
          autoPlayAnimationDuration: const Duration(seconds: 1),
        ),
        itemBuilder: (context, itemIndex, pageViewIndex) {
          return GestureDetector(
            onTap: () {
              // Navigate to MovieDetailScreen
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(
                            movie: snapshot.data[itemIndex],
                          )));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                  height: 300,
                  width: 200,
                  child: snapshot.data[itemIndex].posterPath != null
                      ? CachedNetworkImage(
                          // Use the CachedNetworkImage widget to display the movie poster
                          imageUrl:
                              '${ApiConstants.BASE_IMAGE_URL}${snapshot.data[itemIndex].posterPath}',
                          fit: BoxFit.cover,
                        )
                      : const Center(
                          // Display noImage message if no image is provided from the API
                          child: Text(MessageConstants.imageErrorMessage))),
            ),
          );
        },
      ),
    );
  }
}
