import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_test/core/utils/data_state.dart';
import 'package:movie_test/features/movies/data/models/movie_list_response_model.dart';
import 'package:movie_test/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:movie_test/features/movies/domain/usecases/search_movies.dart';
import 'package:movie_test/features/search/presentation/cubit/search_cubit.dart';
import 'package:movie_test/features/search/presentation/cubit/search_state.dart';
import 'package:movie_test/features/series/data/models/series_list_response_model.dart';
import 'package:movie_test/features/series/domain/usecases/get_popular_series.dart';
import 'package:movie_test/features/series/domain/usecases/search_series.dart';

import '../../../helpers/mock_data.dart';

class MockGetPopularMovies extends Mock implements GetPopularMovies {}
class MockGetPopularSeries extends Mock implements GetPopularSeries {}
class MockSearchMovies extends Mock implements SearchMovies {}
class MockSearchSeries extends Mock implements SearchSeries {}

void main() {
  late MockGetPopularMovies mockPopularMovies;
  late MockGetPopularSeries mockPopularSeries;
  late MockSearchMovies mockSearchMovies;
  late MockSearchSeries mockSearchSeries;

  setUp(() {
    mockPopularMovies = MockGetPopularMovies();
    mockPopularSeries = MockGetPopularSeries();
    mockSearchMovies = MockSearchMovies();
    mockSearchSeries = MockSearchSeries();
  });

  SearchCubit buildCubit() => SearchCubit(
        getPopularMovies: mockPopularMovies,
        getPopularSeries: mockPopularSeries,
        searchMovies: mockSearchMovies,
        searchSeries: mockSearchSeries,
      );

  void stubPopular() {
    when(() => mockPopularMovies()).thenAnswer((_) async => DataSuccess(moviePage()));
    when(() => mockPopularSeries()).thenAnswer((_) async => DataSuccess(seriesPage()));
  }

  group('SearchCubit', () {
    group('initial load', () {
      blocTest<SearchCubit, SearchState>(
        'emits popular movies and series',
        setUp: stubPopular,
        build: buildCubit,
        expect: () => [
          SearchState(moviesResponse: moviePage(), seriesResponse: seriesPage()),
        ],
      );
    });

    group('search', () {
      final searchMoviesResult = moviePage(page: 1, totalPages: 5);
      final searchSeriesResult = seriesPage(page: 1, totalPages: 2);

      blocTest<SearchCubit, SearchState>(
        'emits search results for query',
        setUp: () {
          stubPopular();
          when(() => mockSearchMovies('batman'))
              .thenAnswer((_) async => DataSuccess(searchMoviesResult));
          when(() => mockSearchSeries('batman'))
              .thenAnswer((_) async => DataSuccess(searchSeriesResult));
        },
        build: buildCubit,
        act: (cubit) async {
          await Future<void>.delayed(Duration.zero);
          await cubit.search('batman');
        },
        skip: 1,
        expect: () => [
          SearchState(
            moviesResponse: moviePage(),
            seriesResponse: seriesPage(),
            isLoading: true,
            query: 'batman',
          ),
          SearchState(
            moviesResponse: searchMoviesResult,
            seriesResponse: searchSeriesResult,
            query: 'batman',
          ),
        ],
      );

      blocTest<SearchCubit, SearchState>(
        'reloads popular when query is cleared',
        setUp: stubPopular,
        build: buildCubit,
        act: (cubit) async {
          await Future<void>.delayed(Duration.zero);
          await cubit.search('');
        },
        skip: 1,
        verify: (_) => verify(() => mockPopularMovies()).called(2),
      );
    });

    group('loadMoreMovies', () {
      final page1 = moviePage(page: 1, totalPages: 2, results: [movieModel(id: 1)]);
      final page2 = moviePage(page: 2, totalPages: 2, results: [movieModel(id: 2)]);

      blocTest<SearchCubit, SearchState>(
        'appends next page of popular movies',
        setUp: () {
          when(() => mockPopularMovies()).thenAnswer((_) async => DataSuccess(page1));
          when(() => mockPopularMovies(2)).thenAnswer((_) async => DataSuccess(page2));
          when(() => mockPopularSeries()).thenAnswer((_) async => DataSuccess(seriesPage()));
        },
        build: buildCubit,
        act: (cubit) async {
          await Future<void>.delayed(Duration.zero);
          await cubit.loadMoreMovies();
        },
        skip: 1,
        expect: () => [
          SearchState(
            moviesResponse: page1.copyWith(
              results: [...page1.results, ...page2.results],
              page: 2,
              totalPages: 2,
            ),
            seriesResponse: seriesPage(),
          ),
        ],
      );
    });

    group('loadMoreSeries', () {
      final page1 = seriesPage(page: 1, totalPages: 2, results: [seriesModel(id: 1)]);
      final page2 = seriesPage(page: 2, totalPages: 2, results: [seriesModel(id: 2)]);

      blocTest<SearchCubit, SearchState>(
        'appends next page of popular series',
        setUp: () {
          when(() => mockPopularMovies()).thenAnswer((_) async => DataSuccess(moviePage()));
          when(() => mockPopularSeries()).thenAnswer((_) async => DataSuccess(page1));
          when(() => mockPopularSeries(2)).thenAnswer((_) async => DataSuccess(page2));
        },
        build: buildCubit,
        act: (cubit) async {
          await Future<void>.delayed(Duration.zero);
          await cubit.loadMoreSeries();
        },
        skip: 1,
        expect: () => [
          SearchState(
            moviesResponse: moviePage(),
            seriesResponse: page1.copyWith(
              results: [...page1.results, ...page2.results],
              page: 2,
              totalPages: 2,
            ),
          ),
        ],
      );
    });
  });
}
