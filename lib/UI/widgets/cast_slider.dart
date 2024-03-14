import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/api/api_constants.dart';
import 'package:movie_app/constants.dart';

class HorizontalSlider extends StatelessWidget {
  const HorizontalSlider({
    super.key,
    required this.snapshot,
  });
  final AsyncSnapshot snapshot;

  static const double boxWidth = 150;
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
              child: Column(
                children: [
                  // Image
                  ClipRRect(
                    // Setting border radius of image
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 200,
                      width: boxWidth,
                      child: snapshot.data[index].profilePath != null
                          ? CachedNetworkImage(
                              // Use the CachedNetworkImage widget to display the movie poster
                              imageUrl:
                                  '${ApiConstants.BASE_IMAGE_URL}${snapshot.data[index].profilePath}',
                              fit: BoxFit.cover,
                            )
                          : const Center(
                              child:
                                  // Display noImage message if no image is provided from the API
                                  Text(MessageConstants.noImageErrorMessage)),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  //  Name and character box
                  SizedBox(
                    width: boxWidth,
                    child: Column(
                      children: [
                        // Display name of the actor
                        Text(
                          snapshot.data[index].name,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        // Display name of the character they played
                        Text(
                          snapshot.data[index].character,
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
