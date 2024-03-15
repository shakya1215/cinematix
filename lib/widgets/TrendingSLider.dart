
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Importing the carousel_slider package.

import '../newDetail.dart'; // Importing the DetailScreen1 widget.
import 'constants.dart'; // Importing the Constants.imagePath value.

class TrendingSlider extends StatelessWidget {
  const TrendingSlider({
    Key? key,
    required this.snapshot,
  }) : super(key: key);

  final AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    // Check if snapshot data is null or empty
    if (snapshot.data == null || snapshot.data.isEmpty) {
      return SizedBox.shrink(); // Return an empty SizedBox if no data
    }

    return SizedBox(
      width: double.infinity,
      child: CarouselSlider.builder(
        itemCount: snapshot.data!.length,
        options: CarouselOptions(
          height: 300,
          autoPlay: true,
          viewportFraction: 0.55,
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          pageSnapping: true,
          autoPlayAnimationDuration: const Duration(seconds: 2),
        ),
        itemBuilder: (context, itemIndex, pageViewIndex) {
          return GestureDetector(
            onTap: () {
              // Navigate to the DetailScreen1 when the image is tapped.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen1(
                    movie: snapshot.data![itemIndex], // Access data with index
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 300,
                width: 200,
                child: Image.network(
                  // Load the movie poster using the Constants.imagePath.
                  '${Constants.imagePath}${snapshot.data![itemIndex].posterPath}',
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
