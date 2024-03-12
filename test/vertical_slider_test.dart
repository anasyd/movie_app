import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:movie_app/UI/widgets/vertical_slider.dart';
import 'package:movie_app/api/api_constants.dart';
import 'package:movie_app/models/movies.dart';

class MockApiConstants extends Mock
    implements ApiConstants {} // Create a mock for ApiConstants

void main() {
  testWidgets('VerticalSlider builds movie list', (tester) async {
    // Create a mock snapshot with sample movie data

    final mockSnapshot = AsyncSnapshot.withData(ConnectionState.done, [
      Movie(
          title: 'Movie 1',
          overview: 'Overview 1',
          originalTitle: "No Way Up",
          id: 1096197,
          backDropPath: "/mDeUmPe4MF35WWlAqj4QFX5UauJ.jpg",
          voteAverage: 5.894,
          releaseDate: "2024-01-18"),
      Movie(
          title: 'Movie 2',
          overview: 'Overview 2',
          originalTitle: "No Way Up2",
          id: 1096197,
          backDropPath: "/mDeUmPe4MF35WWlAqj4QFX5UauJ.jpg",
          voteAverage: 5.894,
          releaseDate: "2024-01-18"),
    ]);

    // Override the ApiConstants with the mock
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: VerticalSlider(
            snapshot: mockSnapshot,
          ),
        ),
      ),
    );

    // Find the ListView.builder within VerticalSlider
    final listView = find.byType(ListView);
    expect(listView, findsOneWidget);

    // Check if two movie items are displayed
    expect(find.byType(Row), findsNWidgets(2));

    // Verify the first movie item details
    final firstMovieItem = tester.widgetList(find.byType(Row)).first as Row;

    // Expecting the Sized Box in which there is a column of texts
    expect(firstMovieItem.children[2], isA<SizedBox>());

    // Expecting the column
    expect((firstMovieItem.children[2] as SizedBox).child, isA<Column>());

    // Expecting movie title
    expect(
        ((firstMovieItem.children[2] as SizedBox).child as Column).children[0],
        isA<Text>().having((t) => t.data, 'text', 'Movie 1'));

    // Expecting movie overview
    expect(
        ((firstMovieItem.children[2] as SizedBox).child as Column).children[2],
        isA<Text>().having((t) => t.data, 'text', 'Overview 1'));
  });
}
