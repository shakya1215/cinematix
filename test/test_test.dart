import 'package:cinematic/models/movie.dart';
import 'package:cinematic/newDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('Favorite button color changes when pressed', (WidgetTester tester) async {
    // Create a Movie object for testing
    final movie = Movie(
      
      title: 'Test Movie',
      posterPath: 'test_poster.jpg',
      overView: 'Test overview',
      releaseDate: '2024-01-01',
      voteAverage: 8.5,
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: DetailScreen1(movie: movie),
    ));

    // Find the favorite button
    final favoriteButton = find.byIcon(Icons.favorite);

    // Get the initial color of the favorite button
    final initialColor = tester.widget<IconButton>(favoriteButton).color;

    // Tap the favorite button
    await tester.tap(favoriteButton);
    await tester.pump();

    // Get the color of the favorite button after tapping
    final afterTapColor = tester.widget<IconButton>(favoriteButton).color;

    // Verify that the color of the favorite button changes after tapping
    expect(afterTapColor, isNot(initialColor));
  });
}
