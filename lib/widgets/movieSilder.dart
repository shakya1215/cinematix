import 'package:flutter/material.dart';

import '../newDetail.dart'; // Importing the DetailScreen1 widget.
import 'constants.dart'; // Importing the Constants.imagePath value.

class MovieSlider extends StatelessWidget {
  const MovieSlider({
    Key? key,
    required this.snapshot,
  }) : super(key: key);

  final AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                // Navigate to the DetailScreen1 when the image is tapped.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen1(
                      movie: snapshot.data[index], // Pass the selected movie to the DetailScreen1 widget.
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 200,
                  width: 150,
                  child: Image.network(
                    // Load the movie poster using the Constants.imagePath.
                    '${Constants.imagePath}${snapshot.data![index].posterPath}',
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
