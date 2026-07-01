import 'package:flutter_test/flutter_test.dart';
import 'package:movie_test/features/movies/presentation/cubit/movie_list_state.dart';

import '../../../helpers/mock_data.dart';

void main() {
  group('MovieListState', () {
    group('hasMore', () {
      test('false when response is null', () {
        expect(const MovieListState().hasMore, isFalse);
      });

      test('true when page < totalPages', () {
        final state = MovieListState(response: moviePage(page: 1, totalPages: 3));
        expect(state.hasMore, isTrue);
      });

      test('false when page == totalPages', () {
        final state = MovieListState(response: moviePage(page: 3, totalPages: 3));
        expect(state.hasMore, isFalse);
      });

      test('false when page > totalPages', () {
        final state = MovieListState(response: moviePage(page: 4, totalPages: 3));
        expect(state.hasMore, isFalse);
      });
    });

    group('movies', () {
      test('returns empty list when response is null', () {
        expect(const MovieListState().movies, isEmpty);
      });

      test('maps results to Movie entities', () {
        final model = movieModel(id: 42);
        final state = MovieListState(
          response: moviePage(results: [model]),
        );
        expect(state.movies.length, 1);
        expect(state.movies.first.id, 42);
        expect(state.movies.first.title, 'Movie 42');
      });
    });
  });
}
